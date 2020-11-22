//
//  NetworkService.swift
//  VKgram
//
//  Created by Andrey on 20/10/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkService { // TODO: to separate NetworkService and DataFetcher
    
    let dispatchGroup = DispatchGroup()
    
    func getLoginForm() -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = API.scheme
        urlComponents.host = API.authHost
        urlComponents.path = API.authPath
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: API.clientID),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "+8194"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: API.version)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        return request
        
    }
    
    func getUserInfo(userId:Int) -> Promise<UserInfoWelcome>? {
        
        guard let token = Session.shared.token else { return nil }
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = API.scheme
        urlConstructor.host = API.host
        urlConstructor.path = API.getUserInfo
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_ids", value: "\(userId)"),
            URLQueryItem(name: "fields", value: "bdate, photo_200_orig"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: API.version)
        ]

        let promise = firstly {
            URLSession.shared.dataTask(.promise, with: urlConstructor.url!)
        }.compactMap {
          return try JSONDecoder().decode(UserInfoWelcome.self, from: $0.data)
        }
        promise.catch { error in
                debugPrint(urlConstructor.path, error.localizedDescription)
            }
            return promise
        }
        
    
    func getUserGroups(userId: Int) -> Promise<GroupsWelcome>? {
        
        guard let token = Session.shared.token else { return nil }
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = API.scheme
        urlConstructor.host = API.host
        urlConstructor.path = API.getUserGroups
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: "\(userId)"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: API.version)
        ]
        
        let promise = firstly {
            URLSession.shared.dataTask(.promise, with: urlConstructor.url!)
        }.compactMap {
            return try JSONDecoder().decode(GroupsWelcome.self, from: $0.data)
        }
        promise.catch { error in
            debugPrint(error.localizedDescription)
        }
        return promise
        
    }
    
    func getUserPhotos(userId: Int) -> Promise<PhotoWelcome>? {
        
        guard let token = Session.shared.token else { return nil }
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = API.scheme
        urlConstructor.host = API.host
        urlConstructor.path = API.getUserPhotos
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(userId)"),
            URLQueryItem(name: "album_id", value: "wall"),
            URLQueryItem(name: "count", value: "1000"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: API.version)
        ]
        
        //        debugPrint(urlConstructor.url!)
        
        let promise = firstly {
            URLSession.shared.dataTask(.promise, with: urlConstructor.url!)
        }.compactMap {
            return try JSONDecoder().decode(PhotoWelcome.self, from: $0.data)
        }
        promise.catch { error in
            debugPrint(error.localizedDescription)
        }
        return promise
    }
    
    func searchGroups(queryText: String, completion: @escaping (Any?) -> Void) {
        
        guard let userId = Session.shared.userId else { return }
        guard let token = Session.shared.token else { return }
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = API.scheme
        urlConstructor.host = API.host
        urlConstructor.path = API.searchGroups
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: "\(queryText)"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: API.version)
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            
            completion(json)
        }
        
        task.resume()
        
    }
    
    func getUserFriends(userId: Int) -> Promise<UserWelcome>? {
        
        guard let token = Session.shared.token else { return nil }
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = API.scheme
        urlConstructor.host = API.host
        urlConstructor.path = API.getUserFriends
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: "\(userId)"),
            URLQueryItem(name: "count", value: "5000"),
            URLQueryItem(name: "fields", value: "photo_200"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: API.version)
        ]
        
        let promise = firstly {
            URLSession.shared.dataTask(.promise, with: urlConstructor.url!)
        }.compactMap {
            return try JSONDecoder().decode(UserWelcome.self, from: $0.data)
        }
        promise.catch { error in
            debugPrint(urlConstructor.path, error.localizedDescription)
        }
        return promise
        
    }
    
    
    
    func getNewsFeedItems() -> Promise<(ItemWrappedResponse, ProfileWrappedResponse, GroupWrappedResponse)>? {
        
        guard let token = Session.shared.token else { return nil } // TODO: сделать через catch и убрать nil
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = API.scheme
        urlConstructor.host = API.host
        urlConstructor.path = API.getNewsFeed
        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post, photo"),
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "access_token", value: "\(token)"),
            URLQueryItem(name: "v", value: API.version)
        ]
        
        func parseItem(data: Data) -> Promise<ItemWrappedResponse> {
            return Promise { seal in
            let decoder = JSONDecoder()
            let result = try decoder.decode(ItemWrappedResponse.self, from: data)
                seal.resolve(.fulfilled(result))
            }
        }
        
        func parseProfile(data: Data) -> Promise<ProfileWrappedResponse> {
            return Promise { seal in
            let decoder = JSONDecoder()
            let result = try decoder.decode(ProfileWrappedResponse.self, from: data)
                seal.resolve(.fulfilled(result))
            }
        }
        
        func parseGroup(data: Data) -> Promise<GroupWrappedResponse> {
            return Promise { seal in
            let decoder = JSONDecoder()
            let result = try decoder.decode(GroupWrappedResponse.self, from: data)
                seal.resolve(.fulfilled(result))
            }
        }
        
        return firstly {
            URLSession.shared.dataTask(.promise, with: urlConstructor.url!)
        }.then (on: DispatchQueue.global(qos: .background)) { response in
            when(fulfilled:parseItem(data: response.data), parseProfile(data: response.data), parseGroup(data: response.data))
        }
    }
    
}



