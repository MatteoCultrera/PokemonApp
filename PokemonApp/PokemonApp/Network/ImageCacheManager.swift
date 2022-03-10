//
//  ImageCacheManager.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 05/03/22.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    static var shared: ImageCacheManager = ImageCacheManager()
    let imageCache = NSCache<NSString, AnyObject>()
    let imageQueue = DispatchQueue.global(qos: .utility)
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
        
        
        if let cachedImage = self.imageCache.object(forKey: NSString(string: urlString)) as? UIImage{
            completion(cachedImage)
            return
        }
        
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { [weak self]
            (data, urlResponse, error) in
            guard let self = self else { return }
            if let data = data {
                let image = UIImage(data: data)
                if let image = image {
                    self.imageCache.setObject(image, forKey: NSString(string: urlString))
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
        
        
    }
    
}
