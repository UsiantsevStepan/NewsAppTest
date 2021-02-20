//
//  NewsImage.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 19.02.2021.
//

import UIKit

class NewsImage: UIImageView {
    static var imageCache = NSCache<NSString, UIImage>()
    
    private var imageUrlString: String?
    
    func downloadImage(urlString: String) {
        imageUrlString = urlString
        
        image = #imageLiteral(resourceName: "placeholder")
        
//        print(NewsImage.imageCache.object(forKey: urlString as NSString))
        if let cachedImage = NewsImage.imageCache.object(forKey: urlString as NSString) {
            image = cachedImage
        } else {
            guard let url = URL(string: urlString) else { return }
            
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 5)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard error == nil,
                      let imageData = data,
                      let self = self
                else {
                    return
                }
                
                guard let image = UIImage(data: imageData) else { return }
                
                DispatchQueue.main.async {
                    if self.imageUrlString == urlString {
                        self.image = image
                    }
                    
                    NewsImage.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
            }
            dataTask.resume()
        }
    }
}
