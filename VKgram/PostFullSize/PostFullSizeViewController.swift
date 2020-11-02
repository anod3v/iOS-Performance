//
//  PostFullSizeViewController.swift
//  VKgram
//
//  Created by Andrey on 19/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class PostFullSizeViewController: UIViewController {
//    // TODO: to improve swipe, to make it response to pan gesture
//    // TODO: to add like button, counter, share button etc.
//
//    var selectedPost = Post()
//
//    var index: Int?
//
//    var imageView: UIImageView = {
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let layer = CALayer()
//
//    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
//
//        if sender.direction == .right {
////            print("left swipe made")
//            if selectedPost.photoUrls.indices.contains(index! - 1) {
//
//                UIView.transition(with: imageView,
//                                  duration: 0.75,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.imageView.image = UIImage(contentsOfFile: self.selectedPost.photoUrls[self.index! - 1].path) },
//                                  completion: nil)
//                index! -= 1
//            }
//        }
//        if sender.direction == .left {
////            print("right swipe made")
//            if selectedPost.photoUrls.indices.contains(index! + 1) {
//
//                UIView.transition(with: imageView,
//                                  duration: 0.75,
//                                  options: .transitionCrossDissolve,
//                                  animations: { self.imageView.image = UIImage(contentsOfFile: self.selectedPost.photoUrls[self.index! + 1].path) },
//                                  completion: nil)
//                index! += 1
//            }
//
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        configureImageView()
//        view.addSubview(imageView)
//        setupConstraints()
//        addGestureRecognizer()
//    }
//
//    func configureImageView() {
//        guard let path = selectedPost.photoUrls.first?.path
//            else {
//                return imageView.image = UIImage(named: "not found")
//        }
//        index = selectedPost.photoUrls.startIndex
//        imageView.image = UIImage(contentsOfFile: path)
//    }
//
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageView.heightAnchor.constraint(equalTo: view.widthAnchor), // TODO: what if the image height is different
//            imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
//        ])
//    }
//    func addGestureRecognizer() {
//        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
//        leftRecognizer.direction = .left
//        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
//        rightRecognizer.direction = .right
//        self.view.addGestureRecognizer(leftRecognizer)
//        self.view.addGestureRecognizer(rightRecognizer)
//    }
}
