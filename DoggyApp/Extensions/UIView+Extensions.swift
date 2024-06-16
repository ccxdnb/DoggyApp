//
//  UIView+Extensions.swift
//  DoggyApp
//
//  Created by Joaquin Wilson.
//

import UIKit

extension UIView {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = .init(origin: .zero, size: .init(width: self.frame.width, height: self.frame.height))

        self.layer.insertSublayer(gradientLayer, at:0)
        self.layoutSubviews()
    }

    func setCellShadow(cornerRadius: CGFloat) {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .init(width: 0, height: 4)
        self.layer.shadowRadius = 4
    }

    func setBlurBackground(cornerRadius: CGFloat, style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = cornerRadius
        blurView.layer.masksToBounds = true
        blurView.layer.opacity = 0.7
        self.insertSubview(blurView, at: 0)
    }

    func showActivityIndicator() {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.center
        self.addSubview(activityView)
        activityView.startAnimating()
        activityView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: activityView,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: self,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           multiplier: 1,
                           constant: 0).isActive = true

            NSLayoutConstraint(item: activityView,
                               attribute: NSLayoutConstraint.Attribute.centerY,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: self,
                               attribute: NSLayoutConstraint.Attribute.centerY,
                               multiplier: 1,
                               constant: 0).isActive = true
    }

    func hideActivityIndicator(){
        guard let activityView: UIActivityIndicatorView = self.subviews.first(where: { view in
            return (view as? UIActivityIndicatorView) != nil
        }) as? UIActivityIndicatorView else { return }
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
}
