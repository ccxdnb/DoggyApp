//
//  SingleBreedCell.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import UIKit

class SingleBreedCell: UICollectionViewCell {
    private var subscriptions = Set<AnyCancellable>()
    private var activityView: UIActivityIndicatorView?

    @IBOutlet private weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 10
            container.layer.masksToBounds = true
        }
    }

    @IBOutlet private weak var titleContainer: UIView! {
        didSet {
            titleContainer.backgroundColor = .clear
            titleContainer.setBlurBackground(cornerRadius: 5)
        }
    }

    @IBOutlet var breadLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCellShadow(cornerRadius: 10)
        self.container.setBlurBackground(cornerRadius: 10)
        showActivityIndicator()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.removeAll()
    }

    func setup(title: String) {
        self.breadLabel.text = title
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func configure(imageURL: String) {
        if let url = URL(string: imageURL) {
            ImageLoader.shared.loadImage(from: url)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { image in
//                    DispatchQueue.main.async { [weak self] in
                        self.set(image: image)
//                    }
                }).store(in: &self.subscriptions)
        } else {
            self.imageView.image = nil
        }
    }

    func set(image: UIImage?, animated: Bool = true) {
        if !animated {
            self.imageView.image = image
            return
        }
        UIView.transition(with: self.imageView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.imageView.image = image  },
                          completion: { _ in self.layoutIfNeeded() })
        hideActivityIndicator()
    }

    func cancelSubscriptions() {
        self.subscriptions.forEach {
            $0.cancel()
        }
    }
}
