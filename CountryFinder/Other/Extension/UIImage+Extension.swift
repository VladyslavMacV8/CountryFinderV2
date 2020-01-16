//
//  UIImage+Extension.swift
//  CountryFinder
//
//  Created by Vladyslav Kudelia on 7/13/19.
//  Copyright © 2019 Vladyslav Kudelia. All rights reserved.
//

import UIKit

private class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!
    
    static let shared = ImageCache()
    
    private init() {
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

extension UIImageView {
    
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImageAsync(with urlString: String?, and placeholder: String?) {
        weak var oldTask = currentTask
        oldTask?.cancel()
        currentTask = nil
        
        image = nil
        
        guard let urlString = urlString else { return }
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            image = cachedImage
            return
        }
        
        let url = URL(string: urlString)!
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.image = UIImage(named: placeholder ?? "")
                }
                return
            }
            
            ImageCache.shared.save(image: downloadedImage, forKey: urlString)
            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }

        currentTask = task
        task.resume()
    }
}
