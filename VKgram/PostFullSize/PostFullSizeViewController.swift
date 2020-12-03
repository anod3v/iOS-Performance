//
//  PostFullSizeViewController.swift
//  VKgram
//
//  Created by Andrey on 19/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class PostFullSizeViewController: UIViewController {
    // TODO: to improve swipe, to make it response to pan gesture
    // TODO: to add like button, counter, share button etc.
    
    var selectedPostIndex: Int?
    
    var index: Int? { didSet {
        if let photo = photos?[self.index!] {
            configureInfoBars(for: photo) }
        } }
    
    var photos: [PhotoRepresentable]? = []
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var likesCountLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.semiBoldOfSize16 // TODO: to add to constants
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var likeBarView: LikeBarView = {
        let view = LikeBarView(theme: .white)
//        view.backgroundColor = .orange
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var postTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.regularOfSize16
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
//        label.backgroundColor = .systemYellow
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let layer = CALayer()
    
    func configureInfoBars(for photo: PhotoRepresentable) {
        likeBarView.likeCounterLabel.text = photo.likes
        postTextLabel.text = (photo.text == "" ? "No description here" : photo.text)
        
    }
    
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        
        guard photos != nil else { return }
        guard let photo = photos?[index!] else { return }
        
        if sender.direction == .right {
            print("left swipe made")
            //            if selectedPost.photoUrls.indices.contains(index! - 1) {
            if (photos?.indices.contains(index! - 1))! {
                
                UIView.transition(with: imageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    PhotoService.shared.photo(url: (self.photos?[self.index! - 1].photo)!) { image in
                                        self.imageView.image = image }}, // TODO: to implement via interface
                    completion: nil)
                index! -= 1
            }
        }
        if sender.direction == .left {
            print("right swipe made")
            if (photos?.indices.contains(index! + 1))! {
                
                UIView.transition(with: imageView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    PhotoService.shared.photo(url: (self.photos?[self.index! + 1].photo)!) { image in
                                        self.imageView.image = image }},
                                  completion: nil)
                index! += 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureImageView()
        view.addSubview(imageView)
        view.addSubview(likesCountLabel)
        view.addSubview(postTextLabel)
        view.addSubview(likeBarView)
        setupConstraints()
        addGestureRecognizer()
    }
    
    func configureImageView() {
        
        index = selectedPostIndex
        
        guard ((photos?[selectedPostIndex!]) != nil) else { return }
        
        PhotoService.shared.photo(url: (photos?[selectedPostIndex!].photo)!) { image in
            self.imageView.image = image
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor), // TODO: what if the image height is different
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            likeBarView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            likeBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            likeBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            postTextLabel.topAnchor.constraint(equalTo: likeBarView.bottomAnchor, constant: 20),
            postTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            postTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
        ])
    }
    func addGestureRecognizer() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
    }
}

class PhotoRepresentable {
    var photo: String
    var likes: String
    var text: String
    
    init(photo: String, likes: String, text: String) {
        self.photo = photo
        self.likes = likes
        self.text = text
    }
}
