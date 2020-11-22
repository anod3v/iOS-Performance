//
//  GroupsNetworkResponse.swift
//  VKgram
//
//  Created by Andrey on 21/11/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct GroupsWelcome: Codable {
    let response: GroupsResponse
}

// MARK: - Response
struct GroupsResponse: Codable {
    let count: Int
    let items: [GroupItem]
}

// MARK: - Item
struct GroupItem: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: TypeEnum
    let photo50, photo100, photo200: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

enum TypeEnum: String, Codable {
    case group = "group"
    case page = "page"
}
