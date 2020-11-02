//
//  NewsFeedCollectionViewHeader.swift
//  VKgram
//
//  Created by Andrey on 09/10/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class NewsFeedCollectionViewHeader: UIView {
    
        var textLabel: UILabel = {
            let label = UILabel()
            label.font = label.font.withSize(20) // TODO: to add to constants
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.backgroundColor = .systemYellow
    
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
        override init(frame: CGRect) {
            super.init(frame: frame)
    //        print("NewsFeedCollectionViewCell frame is:", frame)
            addViews()
            setupConstraints()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
            addSubview(textLabel)

        }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
                   textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                   textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                   textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                   textLabel.heightAnchor.constraint(equalToConstant: 200), //TODO: to add to constants
        ])
    }

}
