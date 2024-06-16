//
//  FavoritePicturesViewController.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import Combine
import UIKit

class FavoritePicturesViewController: UIViewController {

    private var searchBar: UISearchController = {
           let searchBar = UISearchController()
            searchBar.searchBar.placeholder = "Search by breed"
            searchBar.searchBar.searchBarStyle = .minimal
           return searchBar
       }()

    @IBOutlet var collectionView: UICollectionView? {
        didSet {
            self.collectionView?.collectionViewLayout = CollectionViewCompositionalLayouts.basic.layout
            self.collectionView?.dataSource = self
            self.collectionView?.register(.init(nibName: "FavoritePictureCell", bundle: nil), forCellWithReuseIdentifier: "FavoritePictureCell")
        }
    }

    let viewModel: FavoritePicturesViewModel
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: FavoritePicturesViewModel) {
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
        setGradientBackground(colorTop: .white, colorBottom: .orange)
        setupNavigationItem()
    }

    private func setupNavigationItem() {
        navigationItem.title  = "Favorite Pictures"
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    private func setupBindings() {

        viewModel.$filteredPictures.sink(receiveValue: { [weak self] _ in
            self?.collectionView?.reloadData()
        }).store(in: &subscriptions)
    }
}

extension FavoritePicturesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.filteredPictures.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dogPictureCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritePictureCell", for: indexPath) as? FavoritePictureCell else { fatalError("cell not found") }
        
        dogPictureCell.configure(with: self.viewModel.filteredPictures[indexPath.row])

        return dogPictureCell
    }
}

extension FavoritePicturesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        self.viewModel.didSearchBreedWith(query: query)
    }
}
