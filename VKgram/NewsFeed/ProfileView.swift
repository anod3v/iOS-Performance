//
//  ProfileView.swift
//  VKgram
//
//  Created by Andrey on 20/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    var sourceImage: RoundCornersImageView = {
        let view = RoundCornersImageView(frame: .zero)
//        view.contentMode = .scaleAspectFill
        view.backgroundColor = #colorLiteral(red: 1, green: 0.3864146769, blue: 0.4975627065, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    var sourceName: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.semiBoldOfSize16 // TODO: to add to constants
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sourceImage)
        addSubview(sourceName)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            sourceImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            sourceImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),  // TODO: to add to constants
            sourceImage.widthAnchor.constraint(equalTo: sourceImage.heightAnchor),
            sourceImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),

            sourceName.centerYAnchor.constraint(equalTo: centerYAnchor),
            sourceName.leadingAnchor.constraint(equalTo: sourceImage.trailingAnchor, constant: 8),
            sourceName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            sourceName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
            
        ])
        
    }
    
}
