//
//  Constants.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import UIKit

struct Constants {
    static var padding: Int = 16
    static var imageMemoryCacheLimit: Int = 1024 * 1024 * 150 //100mb
    static var imageCacheCountLimit: Int = 100

    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var screenheight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

