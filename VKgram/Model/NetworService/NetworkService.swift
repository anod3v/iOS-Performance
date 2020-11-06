//
//  NetworkService.swift
//  VKgram
//
//  Created by Andrey on 20/10/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class NetworkService { // TODO: to separate NetworkService and DataFetcher
    
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
    
    func getUserInfo(userId: Int, completion: @escaping (UserInfoWelcome?, Error?) -> Void) {
        
        guard let token = Session.shared.token else { return }
        
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
        
        let decoder = JSONDecoder()
        
        debugPrint("urlConstructor.url!:", urlConstructor.url!)
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//            debugPrint("jsonData:", jsonData)
            
            guard let dataResponse = data, error == nil else {
                debugPrint(error?.localizedDescription ?? "Response Error")
                return }
            
            do {
                
                let result = try decoder.decode(UserInfoWelcome.self, from: dataResponse)
//                debugPrint("result:", result)
                completion(result, nil)
                
            } catch (let error) {
                
                completion(nil, error)
            }
        }
        
        task.resume()

    }
    
    func getUserGroups(userId: Int, completion: @escaping (Any?) -> Void) {
        
        guard let token = Session.shared.token else { return }
        
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
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in

            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            
            completion(json)
        }

        task.resume()

    }
    
    func getUserPhotos(userId: Int, callback: @escaping (PhotoWelcome?, Error?) -> Void) {
        
        guard let token = Session.shared.token else { return }
        
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
        
        let decoder = JSONDecoder()
        
         let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                   
                   let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//                   debugPrint("jsonData:", jsonData)
                   
                   guard let dataResponse = data, error == nil else {
                       debugPrint(error?.localizedDescription ?? "Response Error")
                       return }
                   
                   do {
                       
                       let result = try decoder.decode(PhotoWelcome.self, from: dataResponse)
//                       debugPrint("result:", result)
                       callback(result, nil)
                       
                   } catch (let error) {
                       
                       callback(nil, error)
                   }
               }
               
               task.resume()

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
    
    func getUserFriends(userId: Int, callback: @escaping (UserWelcome?, Error?) -> Void) {
        
        guard let token = Session.shared.token else { return }
        
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
        
//        debugPrint(urlConstructor.url!)
        
        let decoder = JSONDecoder()
        
         let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                   
                   let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//                   debugPrint("jsonData:", jsonData)
                   
                   guard let dataResponse = data, error == nil else {
                       debugPrint(error?.localizedDescription ?? "Response Error")
                       return }
                   
                   do {
                       
                       let result = try decoder.decode(UserWelcome.self, from: dataResponse)
//                       debugPrint("result:", result)
                       callback(result, nil)
                       
                   } catch (let error) {
                       
                       callback(nil, error)
                   }
               }
               
               task.resume()

    }
  


    func getNewsFeedItems(callback: @escaping (Welcome?, Error?) -> Void) {
        
        guard let token = Session.shared.token else { return }
        
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
        
//        debugPrint(urlConstructor.url!)
        
        let decoder = JSONDecoder()
        
         let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
                   
                   let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//                   debugPrint("jsonData:", jsonData)
                   
                   guard let dataResponse = data, error == nil else {
                       debugPrint(error?.localizedDescription ?? "Response Error")
                       return }
                   
                   do {
                       
                       let result = try decoder.decode(Welcome.self, from: dataResponse)
//                       debugPrint("resultant NewsFeed:", result)
                       callback(result, nil)
                       
                   } catch (let error) {
                       
                       callback(nil, error)
                   }
               }
               
               task.resume()

    }
  
}

