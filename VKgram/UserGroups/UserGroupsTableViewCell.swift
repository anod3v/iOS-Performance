//
//  UserGroupsTableViewCell.swift
//  VKgram
//
//  Created by Andrey on 21/11/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class UserGroupsTableViewCell: UITableViewCell { // TODO: to add search bar
    
    var groupImage: RoundCornersImageView = {
        let view = RoundCornersImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .blue
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var groupName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .brown
        label.font = Constants.Fonts.regularOfSize16
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedGroup: GroupItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .red
        addSubview(groupImage)
        addSubview(groupName)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(for group: GroupItem) {
        groupName.text = "\(group.name)"
        PhotoService.shared.photo(url: group.photo200) { image in
            self.groupImage.image = image
        }
        
        selectedGroup = group
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            groupImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            groupImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),  // TODO: to add to constants
            groupImage.widthAnchor.constraint(equalTo: groupImage.heightAnchor),
            groupImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            groupName.centerYAnchor.constraint(equalTo: centerYAnchor),
            groupName.leadingAnchor.constraint(equalTo: groupImage.trailingAnchor, constant: 8),
            
        ])
        
    }
    
    
    
}

