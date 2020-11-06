//
//  NewsFeedTableViewCell.swift
//  VKgram
//
//  Created by Andrey on 20/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    
    weak var delegate: NewsFeedTableViewCellDelegate?
    
    var isExpanded: Bool = false
    
    var profileView: ProfileView = {
        let view = ProfileView()
        view.backgroundColor = .brown
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var photoCollageView: PhotoCollageView = {
        let view = PhotoCollageView()
        view.backgroundColor = .green

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var likeBarView: LikeBarView = {
        let view = LikeBarView()
        view.backgroundColor = .orange

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var postTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regularOfSize16
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .systemYellow
        label.sizeToFit()

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var showMoreButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.Fonts.regularOfSize16
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal) // TODO to put colors in constants
        button.titleLabel?.alpha = 0.5
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("more...", for: .normal)
        button.isHidden = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        showMoreButton.addTarget(self, action: #selector(showMoreText), for: .touchUpInside)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        contentView.addSubview(profileView)
        contentView.addSubview(photoCollageView)
        contentView.addSubview(likeBarView)
        contentView.addSubview(postTextLabel)
        contentView.addSubview(showMoreButton)
    }
    
    @objc func showMoreText() {
//        print("more text button is pressed")
        isExpanded = !isExpanded
        
        postTextLabel.numberOfLines = isExpanded ? 0 : 2
        showMoreButton.setTitle(isExpanded ? "less..." : "more...", for: .normal)
        delegate?.revealPost(for: self)
    }
    
    func configure(item: Item) {
        isExpanded = false
        postTextLabel.text = item.text
        if postTextLabel.calculateMaxLines() <= 2 {
            showMoreButton.isHidden = true
        } else {
           showMoreButton.isHidden = false
        }
        postTextLabel.numberOfLines = 2
        
        likeBarView.likeCounterLabel.text = String(item.likes?.count ?? 0)
        likeBarView.viewsCounterLabel.text = String(item.views?.count ?? 0)
        
        if let photos = item.attachments?.compactMap({$0?.postPhoto})
        { photoCollageView.photos  = photos }
    
        photoCollageView.collectionView.reloadData()
    }
    
    func configureProfile(photo: String?, name: String?) {
        
        let placeHolderImage = UIImage.gifImageWithName("spinner")
        
        profileView.sourceName.text = name
        profileView.sourceImage.loadImageUsingCacheWithURLString(photo!, placeHolder: placeHolderImage) { (bool) in
                    //perform actions if needed
                }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            profileView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 50),

            photoCollageView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            photoCollageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoCollageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoCollageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            likeBarView.topAnchor.constraint(equalTo: photoCollageView.bottomAnchor, constant: 20),
            likeBarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            likeBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            postTextLabel.topAnchor.constraint(equalTo: likeBarView.bottomAnchor, constant: 20),
            postTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            postTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            showMoreButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor),
            showMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            showMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            showMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                
        ])
    }
}

protocol NewsFeedTableViewCellDelegate: class {
    func revealPost(for cell: NewsFeedTableViewCell)
}

