//
//  CollectionViewLayouts.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import UIKit

enum CollectionViewLayouts {
    case verticalList
    case horizontalListSmall

    var flowLayout: UICollectionViewFlowLayout {
        switch self {
        case .verticalList:
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            layout.itemSize = CGSize(width: Constants.screenWidth, height: 300)
            layout.minimumLineSpacing = 16
            return layout
        case .horizontalListSmall:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            layout.itemSize = CGSize(width: 200, height: 270 - Constants.padding*2)
            layout.minimumLineSpacing = 8
            return layout
        }
    }
}

enum CollectionViewCompositionalLayouts {
    case basic

    var layout: UICollectionViewCompositionalLayout {
        switch self {
        case .basic:
            let fraction: CGFloat = 1 / 2
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            group.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let section = NSCollectionLayoutSection(group: group)
            return UICollectionViewCompositionalLayout(section: section)
        }
    }
}

