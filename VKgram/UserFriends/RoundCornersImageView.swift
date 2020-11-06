//
//  RoundView.swift
//  LoginForm
//
//  Created by Andrey on 19/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class RoundCornersImageView: UIImageView {
    
    var radius: CGFloat = 0
    
    init(frame: CGRect, cornerRadius: CGFloat) {
        super.init(frame: frame)
        self.radius = cornerRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        needsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentMode = .scaleAspectFill
        self.radius = self.bounds.size.width/2.0
        layer.cornerRadius = self.radius
        clipsToBounds = true
    }

}
