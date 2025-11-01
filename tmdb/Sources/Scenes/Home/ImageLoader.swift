//
//  ImageLoader.swift
//  tmdb
//
//  Created by Diogo on 19/10/2025.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
        cache.countLimit = 500
        cache.totalCostLimit = 50 * 1024 * 1024 // ~50MB
    }
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString
        
        if let cached = cache.object(forKey: key) {
            DispatchQueue.main.async {
                completion(cached)
            }
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard
                error == nil,
                let data = data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache.setObject(image, forKey: key, cost: data.count)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
