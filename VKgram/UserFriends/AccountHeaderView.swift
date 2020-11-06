//
//  AccountHeaderView.swift
//  VKgram
//
//  Created by Andrey on 03/11/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class AccountHeaderView: UIView {
    
    var profileImage: RoundCornersImageView = {
        let view = RoundCornersImageView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    var profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.semiBoldOfSize14 // TODO: to add to constants
//        label.textColor = UIColor(named: "T2MDarkGrey") // TODO: to add to constants
        label.textAlignment = .left
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regularOfSize12// TODO: to add to constants
//        label.textColor = UIColor(named: "T2MDarkGrey")
        label.textAlignment = .left
        label.alpha = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailsContainerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addFirstLayerOfViews()
        addSecondLayerOfViews()
        updateConstraints()
    }
    
    func addFirstLayerOfViews() {
        detailsContainerView.addSubview(profileNameLabel)
        detailsContainerView.addSubview(phoneNumberLabel)
    }
    
    func addSecondLayerOfViews() {
        addSubview(detailsContainerView)
        addSubview(profileImage)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),  // TODO: to add to constants
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 120),
            
            detailsContainerView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            detailsContainerView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            detailsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            profileNameLabel.topAnchor.constraint(equalTo: detailsContainerView.topAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
            profileNameLabel.heightAnchor.constraint(equalToConstant: 20),

            phoneNumberLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 5),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: detailsContainerView.leadingAnchor),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: detailsContainerView.trailingAnchor),
            phoneNumberLabel.heightAnchor.constraint(equalToConstant: 20),
            
            phoneNumberLabel.bottomAnchor.constraint(equalTo: detailsContainerView.bottomAnchor)
        ])
    }
}

