//
//  BreedListViewController.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import UIKit
import Combine

class BreedListViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.collectionViewLayout = CollectionViewLayouts.verticalList.flowLayout
            self.collectionView?.delegate = self
            self.collectionView?.dataSource = self
            self.collectionView?.prefetchDataSource = self
            self.collectionView?.register(.init(nibName: "SingleBreedCell", bundle: nil), forCellWithReuseIdentifier: "SingleBreedCell")
            self.collectionView?.register(.init(nibName: "MultiBreedCell", bundle: nil), forCellWithReuseIdentifier: "MultiBreedCell")
        }
    }

    private var subscriptions = Set<AnyCancellable>()
    private var prefetchedImages: [IndexPath: String] = [:]
    let viewModel: BreedListviewModel

    init(viewModel: BreedListviewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BreedListViewController", bundle: nil)
        self.setupBindings()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBindings() {
        viewModel.$breeds.sink(receiveValue: { [weak self] _ in
            self?.collectionView?.reloadData()
        }).store(in: &subscriptions)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fetchBreeds()
        setGradientBackground(colorTop: .white, colorBottom: .orange)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        navigationController?.navigationBar.titleTextAttributes = attributes

        self.title = "Breed List"

        let favButton =  UIBarButtonItem(image: .init(systemName: "pawprint.fill"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addTapped))

        favButton.tintColor = .orange

        navigationItem.rightBarButtonItem = favButton
    }

    @objc
    func addTapped () {
        self.viewModel.didPressFavoritePictures()
    }
}

extension BreedListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.breeds.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let breedName: String = viewModel.breeds.map { $0.key }[indexPath.row]

        return cellFor(collectionView,
                       breedName: breedName,
                       subBreeds: viewModel.breeds[breedName] ?? [],
                       indexPath: indexPath)
    }

    private func cellFor(_ collectionView: UICollectionView, breedName: String, subBreeds: [String], indexPath: IndexPath) -> UICollectionViewCell {

        if subBreeds.count > 1 {
            guard let multiBreedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiBreedCell", for: indexPath) as? MultiBreedCell else { fatalError("MultiBreedCell not found") }

            multiBreedCell.setup(title: breedName, subBreeds: subBreeds)
            multiBreedCell.fetchClosure = {[weak self] breed, subBreed, onReceive in
                self?.viewModel.fetchRandomImageFrom(breed: breed, and: subBreed, onReceiveValue: onReceive)
            }
            multiBreedCell.didSelectSubBreed = { [weak self] breed, subBreed in
                self?.viewModel.didSelect(breed: breed, subBreed: subBreed)
            }
            return multiBreedCell
        } else {
            guard let singleBreedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleBreedCell", for: indexPath) as? SingleBreedCell else { fatalError("SingleBreedCell not found") }
            singleBreedCell.setup(title: breedName)
            return singleBreedCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // if data prefetched use prefetched data
        if let singleBreedCell = cell as? SingleBreedCell {
            if let preImage = prefetchedImages[indexPath] {
                singleBreedCell.configure(imageURL: preImage)
                self.prefetchedImages.removeValue(forKey: indexPath)
            } else {
                singleBreedCell.configure(imageURL: "")
                viewModel.fetchRandomImageFrom(breed: self.viewModel.breeds.map{ $0.key }[indexPath.row]) { [weak singleBreedCell] response in
                    singleBreedCell?.configure(imageURL: response.message)
                }
            }
        }
    }
}


extension BreedListViewController: UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //data prefetch to make scrolling smoother
        for indexPath in indexPaths {
            let breedName: String = viewModel.breeds.map { $0.key }[indexPath.row]
            let cell = cellFor(collectionView,
                           breedName: breedName,
                           subBreeds: viewModel.breeds[breedName] ?? [],
                           indexPath: indexPath)

            if let _ = cell as? SingleBreedCell {
                viewModel.fetchRandomImageFrom(breed: breedName) {response in
                    self.prefetchedImages[indexPath] = response.message
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // cancel ongoing subscriptions
        for indexPath in indexPaths {
            let breedName: String = viewModel.breeds.map { $0.key }[indexPath.row]

            let cell = cellFor(collectionView,
                               breedName: breedName,
                               subBreeds: viewModel.breeds[breedName] ?? [],
                               indexPath: indexPath)

            if let singleBreedCell = cell as? SingleBreedCell {
                singleBreedCell.cancelSubscriptions()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let breedName: String = viewModel.breeds.map { $0.key }[indexPath.row]
        self.viewModel.didSelect(breed: breedName)
    }
}
