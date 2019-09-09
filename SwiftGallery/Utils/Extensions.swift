//
//  Extensions.swift
//  SwiftGallery
//
//  Created by Leonardo on 06/09/19.
//  Copyright © 2019 Leonardo. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?

    func loadFromUrlString(urlString: String, activityIndicator: UIActivityIndicatorView?) {
        imageUrlString = urlString

        let url = URL(string: urlString)
        self.image = nil
        activityIndicator?.startAnimating()

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            activityIndicator?.stopAnimating()
            self.image = imageFromCache
            return
        }

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error", error)
                return
            }

            DispatchQueue.main.async {
                print("Done")
                let imageToCache = UIImage(data: data!)

                if self.imageUrlString == urlString {
                    activityIndicator?.stopAnimating()
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        }.resume()
    }
}
