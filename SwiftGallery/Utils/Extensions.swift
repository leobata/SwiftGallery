//
//  Extensions.swift
//  SwiftGallery
//
//  Created by Leonardo on 06/09/19.
//  Copyright © 2019 Leonardo. All rights reserved.
//

import Foundation
import UIKit

// Cache mechanism to avoid downloading the same image many times
let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?

    // Helper method to load image data from an URL to the UIImage object
    func loadFromUrlString(urlString: String, activityIndicator: UIActivityIndicatorView?) {
        imageUrlString = urlString

        let url = URL(string: urlString)
        self.image = nil
        activityIndicator?.startAnimating()

        // If image is already on cache, let's use it
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

                // As this happens on a async context, and cell views from CollectionView
                // are reused, we need to check the urlString being processed at this time
                // is the same from the original call, to avoid setting images for wrong cells
                if self.imageUrlString == urlString {
                    activityIndicator?.stopAnimating()
                    self.image = imageToCache
                }
                // Add downloaded image data to image cache.
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        }.resume()
    }
}
