//
//  NetworkResponse.swift
//  VKgram
//
//  Created by Andrey on 20/10/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

  // MARK: - Welcome
  struct UserWelcome: Decodable {
      let response: UserResponse
  }

  // MARK: - Response
  struct UserResponse: Decodable {
      let count: Int
      let items: [User]
  }

  // MARK: - Item
  struct User: Decodable {
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

struct PhotoWelcome: Decodable {
    let response: PhotoResponse
}

// MARK: - Response
struct PhotoResponse: Decodable {
    let count: Int
    let items: [Photo]
}

// MARK: - Item
struct Photo: Decodable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let height: Int
    let photo130, photo604, photo75, photo807: String
    let text: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case height
        case photo130 = "photo_130"
        case photo604 = "photo_604"
        case photo75 = "photo_75"
        case photo807 = "photo_807"
        case text, width
    }
}

 
