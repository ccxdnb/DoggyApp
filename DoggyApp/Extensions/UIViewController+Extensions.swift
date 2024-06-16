//
//  UIViewController+Extensions.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import UIKit

extension UIViewController {
    func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}

extension UIViewController {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = .init(origin: .zero, size: .init(width: self.view.frame.width + 10, height: self.view.frame.height + 10))

        self.view.layer.insertSublayer(gradientLayer, at:0)
        self.view.layoutSubviews()
    }
}
