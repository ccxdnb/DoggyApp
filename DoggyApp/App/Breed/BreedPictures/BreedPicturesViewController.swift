//
//  BreedPicturesViewController.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import UIKit


class BreedPicturesViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.collectionViewLayout = CollectionViewLayouts.verticalList.flowLayout
            self.collectionView?.dataSource = self
            self.collectionView?.register(.init(nibName: "DogPictureCell", bundle: nil), forCellWithReuseIdentifier: "DogPictureCell")
        }
    }

    private var subscriptions = Set<AnyCancellable>()
    let viewModel: BreedPicturesViewModel

    init(viewModel: BreedPicturesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BreedPicturesViewController", bundle: nil)
        self.setupBindings()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fetchPictures()
        self.setGradientBackground(colorTop: .white, colorBottom: .orange)
        self.title = "\(self.viewModel.breed) \(self.viewModel.subBreed ?? "")"
    }

    private func setupBindings() {
        viewModel.$pictures.sink(receiveValue: { [weak self] _ in
            self?.collectionView?.reloadData()
        }).store(in: &subscriptions)
    }
}

extension BreedPicturesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.pictures.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let singleBreedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogPictureCell", for: indexPath) as? DogPictureCell else { fatalError("cell not found") }

        singleBreedCell.configure(with: self.viewModel.pictures[indexPath.row],
                                  isLiked: self.viewModel.isImageLiked(with: self.viewModel.pictures[indexPath.row]))

        singleBreedCell.didPressLike = { breedName, imageURL, isLiked in
            self.viewModel.didPressLike(breedName: breedName, imageURL: imageURL, isLiked: isLiked)
        }

        return singleBreedCell
    }
}
