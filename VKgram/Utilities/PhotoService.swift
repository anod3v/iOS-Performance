//
//  PhotoService.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 13.11.2020.
//

import UIKit

class PhotoService {
    
    static let shared = PhotoService(lifeTime: 60 * 60 * 24 * 30, placeholderImage: UIImage(named: "noPhoto")!)
    
    private init(lifeTime: TimeInterval, placeholderImage: UIImage) {
        self.cacheLife = lifeTime
        self.placeholder = placeholderImage
    }
    
    let placeholder: UIImage
    
    private let cacheLife: TimeInterval
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var urlLoaded: ((String) -> Void)?
    
    private static let pathName: String = {
    
        let pathName = "images3"
        guard let cachesFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return pathName
        }
        
        let url = cachesFolder.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    
    private func getFileNamePath(url: String) -> String? {
        guard let cachesFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesFolder.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard let filename = getFileNamePath(url: url), let data = image.pngData() else { return }
        
        FileManager.default.createFile(atPath: filename, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        guard
            let filename = getFileNamePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: filename),
            let creationDate = info[FileAttributeKey.modificationDate] as? Date else {
            return nil
        }
        
        
        let lifetime = Date().timeIntervalSince(creationDate)
        
        guard lifetime <= cacheLife, let image = UIImage(contentsOfFile: filename) else {
            return nil
        }
        
        DispatchQueue.main.async {
            self.imageCache.setObject(image, forKey: NSString(string: url))
        }
        
        return image
    }
    
    private func loadPhoto(url: String,completion: @escaping (UIImage) -> Void) {
        var image: UIImage = placeholder
        
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    return
                }
                if httpResponse.statusCode == 200 {
                    
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.imageCache.setObject(downloadedImage, forKey: NSString(string: url.absoluteString))
                            DispatchQueue.main.async {
                                image = downloadedImage
                                completion(image)
                            }
                        }
                    }
                } else {
                    image = self.placeholder
                }
            }).resume()
        } else {
            image = self.placeholder
        }

        completion(image)
    }
    
    
    func photo(url: String, completion: @escaping (UIImage) -> Void) {
        
        if let photo = imageCache.object(forKey: NSString(string: url)) {
            completion(photo)
        } else if let photo = getImageFromCache(url: url) {
            completion(photo)
        } else {
            loadPhoto(url: url, completion: completion)
        }
    }
    
}
