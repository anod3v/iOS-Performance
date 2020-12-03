//
//  NetworkResponse.swift
//  VKgram
//
//  Created by Andrey on 20/10/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

  // MARK: - Welcome
  struct UserWelcome: Codable {
      let response: UserResponse
  }

  // MARK: - Response
  struct UserResponse: Codable {
      let count: Int
      let items: [User]
  }

  // MARK: - Item
  struct User: Codable {
      let id: Int
      let firstName, lastName: String
      let photo_200: String
      let trackCode: String

      enum CodingKeys: String, CodingKey {
          case id
          case firstName = "first_name"
          case lastName = "last_name"
          case photo_200 = "photo_200"
          case trackCode = "track_code"
      }
  }

struct PhotoWelcome: Codable {
    let response: PhotoResponse
}

// MARK: - Response
struct PhotoResponse: Codable {
    let count: Int
    let items: [Photo]
}

// MARK: - Item
struct Photo: Codable, PhotoInterface {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let height: Int
    let photo1280: String?
    let photo130, photo604, photo75, photo807: String
    let postID: Int?
    let text: String
    let width: Int
    let likes: PhotoLikes
    let reposts, comments: PhotoComments
    let canComment: Int
    let tags: PhotoComments
    let photo2560: String?
    
    var bigPhoto: String { return photo604 }
    var smallPhoto: String { return photo130 }
    var repostsCount: String { return String(describing: reposts.count) }
    var likesCount: String { return String(describing: likes.count) }

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case height
        case photo1280 = "photo_1280"
        case photo130 = "photo_130"
        case photo604 = "photo_604"
        case photo75 = "photo_75"
        case photo807 = "photo_807"
        case postID = "post_id"
        case text, width, likes, reposts, comments
        case canComment = "can_comment"
        case tags
        case photo2560 = "photo_2560"
    }
}

// MARK: - Comments
struct PhotoComments: Codable {
    let count: Int
}

// MARK: - Likes
struct PhotoLikes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

 
