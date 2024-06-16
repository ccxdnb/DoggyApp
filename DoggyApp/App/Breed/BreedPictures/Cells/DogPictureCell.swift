//
//  DogPictureCell.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import UIKit

class DogPictureCell: UICollectionViewCell {

    @IBOutlet private weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 10
            container.layer.masksToBounds = true
        }
    }
    
    @IBOutlet private weak var addToFavoriteButton: UIButton! {
        didSet {
            addToFavoriteButton.setImage(.init(systemName: "pawprint.circle"), for: .normal)
            addToFavoriteButton.setImage(.init(systemName: "pawprint.circle.fill"), for: .selected)
            addToFavoriteButton.setImage(.init(systemName: "pawprint.circle.fill"), for: .highlighted)

            addToFavoriteButton.addTarget(self, action: #selector(addToFavoriteButtonPressed), for: .touchUpInside)
        }
    }

    @IBOutlet private weak var favoriteButtonContainer: UIView! {
        didSet {
            favoriteButtonContainer.setBlurBackground(cornerRadius: 5, style: .systemChromeMaterialDark)
        }
    }

    @IBOutlet private weak var imageView: UIImageView!
    private var subscriptions = Set<AnyCancellable>()
    private var breedName: String = ""
    private var imageURL: String = ""
    var didPressLike: (String, String, Bool) -> Void = { _,_,_  in }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCellShadow(cornerRadius: 10)
        self.container.setBlurBackground(cornerRadius: 10)
        self.showActivityIndicator()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = UIImage()
        subscriptions.removeAll()
    }
    

    func configure(with dogPicture: DogPicture, isLiked: Bool = false) {
        self.addToFavoriteButton.isSelected = isLiked
        self.breedName = dogPicture.breed
        self.imageURL = dogPicture.imageURLString

        if let url = URL(string: dogPicture.imageURLString) {
            ImageLoader.shared.loadImage(from: url)
                .sink(receiveValue: { image in
                    DispatchQueue.main.async { [weak self] in
                        self?.set(image: image)
                    }
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
        self.hideActivityIndicator()
    }

    @objc
    func addToFavoriteButtonPressed() {
        self.didPressLike(self.breedName, imageURL, self.addToFavoriteButton.isSelected)
        self.addToFavoriteButton.isSelected.toggle()
    }
}
