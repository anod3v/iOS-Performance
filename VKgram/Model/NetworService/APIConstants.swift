//
//  APIConstants.swift
//  VKgram
//
//  Created by Andrey on 20/10/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let authHost = "oauth.vk.com"
    static let version = "5.68"
    
    static let clientID = "7609893"
    
    static let authPath = "/authorize"
    static let getNewsFeed = "/method/newsfeed.get"
    static let getUserInfo = "/method/users.get"
    static let getUserGroups = "/method/groups.get"
    static let getUserPhotos = "/method/photos.get"
    static let searchGroups = "/method/groups.search"
    static let getUserFriends = "/method/friends.get"
}
