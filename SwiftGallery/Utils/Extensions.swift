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

    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString

        let url = URL(string: urlString)
        self.image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
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
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)

            }
        }.resume()
    }
}
