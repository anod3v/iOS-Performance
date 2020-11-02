//
//  RoundView.swift
//  LoginForm
//
//  Created by Andrey on 19/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class RoundShadowImageView: RoundView {

    var imageView = RoundImageView()

    var image: UIImage!  {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        needsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(imageView)
        needsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1 // TODO: to put into constants
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.height / 2.0).cgPath
    }

    override func updateConstraints() {
        super.updateConstraints()

        imageView.pin(to: self)
        
    }
}

class RoundImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

class RoundView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
