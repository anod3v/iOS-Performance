//
//  UserFriendsTableViewCell.swift
//  VKgram
//
//  Created by Andrey on 17/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class UserFriendsTableViewCell: UITableViewCell { // TODO: to add search bar
    
    var friendImage: RoundShadowImageView = {
        let view = RoundShadowImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var friendName: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20) // TODO: to add to constants
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedFriend = User(id: Int(), firstName: "", lastName: "", photo_200: "", trackCode: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(friendImage)
        addSubview(friendName)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(for friend: User) {
        friendName.text = "\(friend.firstName) \(friend.lastName)"
        friendImage.imageView.loadImageUsingCacheWithURLString(friend.photo_200, placeHolder: nil) { (bool) in
            //perform actions if needed
        }
        
        selectedFriend = friend
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            friendImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),  // TODO: to add to constants
            friendImage.widthAnchor.constraint(equalTo: friendImage.heightAnchor),
            friendImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            friendName.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendName.leadingAnchor.constraint(equalTo: friendImage.trailingAnchor, constant: 8),
            friendName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            friendName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
            
        ])
        
    }
    
    
    
}
