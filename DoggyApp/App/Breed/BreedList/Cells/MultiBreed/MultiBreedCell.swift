//
//  MultiBreedCell.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import UIKit

class MultiBreedCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.collectionViewLayout = CollectionViewLayouts.horizontalListSmall.flowLayout
            self.collectionView?.dataSource = self
            self.collectionView?.delegate = self
            self.collectionView?.register(.init(nibName: "SingleBreedCell", bundle: nil), forCellWithReuseIdentifier: "SingleBreedCell")
        }
    }

    @IBOutlet var breadLabel: UILabel!
    private var breed: String = ""
    private var subBreeds: [String] = []
    private var subscriptions = Set<AnyCancellable>()

    var fetchClosure: (String, String, (@escaping (PictureResponse) -> Void)) -> Void = { _,_,_   in  }
    var didSelectSubBreed: (String, String) -> Void = { _,_ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setBlurBackground(cornerRadius: 10)
    }

    func setup(title: String, subBreeds: [String]) {
        self.breed = title
        self.breadLabel.text = title
        self.subBreeds = subBreeds
        self.collectionView?.reloadData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.subBreeds = []
        self.breed = ""
    }
}

extension MultiBreedCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.subBreeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let singleBreedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleBreedCell", for: indexPath) as? SingleBreedCell else { fatalError("cell not found") }

        singleBreedCell.setup(title: self.subBreeds[indexPath.row])

        self.fetchClosure(breed, self.subBreeds[indexPath.row], { response in
            if let url = URL(string: response.message) {
                ImageLoader.shared.loadImage(from: url)
                    .sink(receiveValue: { image in
                        DispatchQueue.main.async { [weak singleBreedCell] in
                            singleBreedCell?.set(image: image)
                        }
                    }).store(in: &self.subscriptions)
            } else {
                print(response)
            }
        })

        return singleBreedCell
    }
}

extension MultiBreedCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectSubBreed(self.breed, self.subBreeds[indexPath.row])
    }
}
