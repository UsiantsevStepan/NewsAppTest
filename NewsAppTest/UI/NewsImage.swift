//
//  NewsImage.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 19.02.2021.
//

import UIKit

class NewsImage: UIImageView {
    static var imageCache = NSCache<NSString, UIImage>()
    static let imagePlaceholder = #imageLiteral(resourceName: "placeholder")
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private var imageUrlString: String?
    private var task: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setImage(from urlString: String?) {
        guard let urlString = urlString else {
            dropImage()
            return
        }
        
        print("Cache: \(NewsImage.imageCache.object(forKey: urlString as NSString))")
        if let image = NewsImage.imageCache.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .utility).async {
            self.loadAndSetImage(from: urlString)
        }
    }
    
    func cancelTask() {
        task?.cancel()
    }
    
    func dropImage() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.image = NewsImage.imagePlaceholder
        }
    }
    
    private func loadAndSetImage(from urlString: String) {
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else {
            dropImage()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else { return }
            guard error == nil, let data = data, let image = UIImage(data: data) else {
                self.dropImage()
                return
            }
            
                DispatchQueue.main.async {
                    if self.imageUrlString == urlString {
                    self.activityIndicator.stopAnimating()
                    self.image = image
                }
                //                self.image = image
                NewsImage.imageCache.setObject(image, forKey: urlString as NSString)
            }
            
//            NewsImage.imageCache.setObject(image, forKey: urlString as NSString)
            
        }
        task?.resume()
//        self.task = task
    }
}
