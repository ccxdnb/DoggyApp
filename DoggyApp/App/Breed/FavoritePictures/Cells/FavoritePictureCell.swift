//
//  FavoritePictureCell.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import UIKit

class FavoritePictureCell: UICollectionViewCell {
    @IBOutlet private weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 10
            container.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var titleContainer: UIView! {
        didSet {
            titleContainer.backgroundColor = .clear
            titleContainer.setBlurBackground(cornerRadius: 5, style: .prominent)
        }
    }

    @IBOutlet var breadLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    private var breedName: String = ""
    private var imageURL: String = ""
    private var subscriptions = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCellShadow(cornerRadius: 10)
        self.setBlurBackground(cornerRadius: 10)
    }
    override func prepareForReuse() {
        self.imageView.image = nil
    }

    func configure(with dogPicture: DogPicture, isLiked: Bool = false) {
        self.breedName = dogPicture.breed
        self.breadLabel.text = dogPicture.breed
        self.imageURL = dogPicture.imageURLString


        if let url = URL(string: dogPicture.imageURLString) {

            ImageLoader.shared.loadImage(from: url)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { image in
                        self.set(image: image)
                }).store(in: &self.subscriptions)
        } else {
            print(imageURL)
        }
    }

    private func set(image: UIImage?, animated: Bool = true) {
        if !animated {
            self.imageView.image = image
            return
        }
        UIView.transition(with: self.imageView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = image  },
                          completion: { _ in self.layoutIfNeeded() })
    }
}
