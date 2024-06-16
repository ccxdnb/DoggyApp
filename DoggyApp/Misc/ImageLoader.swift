//
//  ImageLoader.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import UIKit
import Combine

public final class ImageLoader {
    public static let shared = ImageLoader() //TODO: Inject this as service instead of singleton
    private let cache: ImageCacheType

    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }

    public func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .eraseToAnyPublisher()
    }
}
