//
//  ProfileInfoNetworkResponse.swift
//  VKgram
//
//  Created by Andrey on 05/11/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct UserInfoWelcome: Decodable {
    let response: [UserInfoResponse]
}

// MARK: - Response
struct UserInfoResponse: Decodable {
    let firstName: String
    let id: Int?
    let lastName, bdate: String
    let photo200_Orig: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case bdate
        case photo200_Orig = "photo_200_orig"
    }
}
