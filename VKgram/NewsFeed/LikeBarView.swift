//
//  LikeBarView.swift
//  LoginForm
//
//  Created by Andrey on 01/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class LikeBarView: UIView {
    
    var likeButton: LikeButton = {
        let button = LikeButton()
        button.strokeColor = .black
        button.tintColor = .systemPink
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var likeCounterLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20) // TODO: to add to constants
        label.numberOfLines = 1
        label.backgroundColor = .lightGray
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewsCounterLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12) // TODO: to add to constants
        label.numberOfLines = 1
        label.backgroundColor = .white
        label.sizeToFit()
        label.alpha = 0.2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var likeTextLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.text = "likes"
//        label.font = UIFont(name: "Montserrat-SemiBold", size: 14) // TODO: to add to constants
//        label.textColor = UIColor(named: "T2MDarkGrey")
        label.textAlignment = .left
        label.backgroundColor = .magenta
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var commentButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "comment")
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plane")
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var viewsView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "views")
        view.image = image
        view.alpha = 0.2
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //-------------
    
    var animationStartDate = Date()
    var startValue = Double()
    var endValue = Double()
    var animationDuration = 1.1
    
    //-------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(likeButton)
        addSubview(likeCounterLabel)
        addSubview(likeTextLabel)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(viewsView)
        addSubview(viewsCounterLabel)
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),  // TODO: to add to constants
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 30), // TODO: to add to constants
            
            commentButton.topAnchor.constraint(equalTo: topAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 20),  // TODO: to add to constants
            commentButton.widthAnchor.constraint(equalTo: commentButton.heightAnchor),
            commentButton.heightAnchor.constraint(equalToConstant: 30), // TODO: to add to constants
            
            shareButton.topAnchor.constraint(equalTo: topAnchor),
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 20),  // TODO: to add to constants
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 30), // TODO: to add to constants
            
            viewsView.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            viewsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),  // TODO: to add to constants
            viewsView.widthAnchor.constraint(equalTo: viewsView.heightAnchor, multiplier: 2),
            viewsView.heightAnchor.constraint(equalToConstant: 15), // TODO: to add to constants
            
            viewsCounterLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            viewsCounterLabel.trailingAnchor.constraint(equalTo: viewsView.leadingAnchor, constant: -20),  // TODO: to add to constants
            viewsCounterLabel.heightAnchor.constraint(equalToConstant: 15), // TODO: to add to constants
            
            likeCounterLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 20),
            likeCounterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            likeCounterLabel.heightAnchor.constraint(equalToConstant: 20), // TODO: to add to constants
            likeCounterLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            likeTextLabel.centerYAnchor.constraint(equalTo: likeCounterLabel.centerYAnchor),
            likeTextLabel.leadingAnchor.constraint(equalTo: likeCounterLabel.trailingAnchor, constant: 8),  // TODO: to add to constants
            likeTextLabel.heightAnchor.constraint(equalToConstant: 20), // TODO: to add to constants
            
        ])
        
    }
    
    @objc func likeButtonPressed(_ sender: Any) {
        
        animationStartDate = Date()
        startValue = Double()
        endValue = Double()
        
        let count = Int(likeCounterLabel.text!) // TODO: to change to if let
        startValue = Double(count! / 2)
        
        if likeButton.filled {
            endValue = Double(count! + 1)
            //                likeCounterLabel.text = String(count! + 1)
        } else {
            let count = Int(likeCounterLabel.text!)
            endValue = Double(count! - 1)
        }
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
        
    }
    
    @objc func handleUpdate(){
        
        likeButton.isUserInteractionEnabled = false
        likeButton.superview?.superview?.superview?.isUserInteractionEnabled = false
        
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            self.likeCounterLabel.text = "\(Int((endValue)))"
            likeButton.isUserInteractionEnabled = true
            likeButton.superview?.superview?.superview?.isUserInteractionEnabled = true
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.likeCounterLabel.text = "\(Int((value)))"
        }
    }
}

