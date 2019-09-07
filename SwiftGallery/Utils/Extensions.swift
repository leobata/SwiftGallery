//
//  Extensions.swift
//  SwiftGallery
//
//  Created by Leonardo on 06/09/19.
//  Copyright © 2019 Leonardo. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error", error)
                return
            }
            
            DispatchQueue.main.async {
                print("Done")
                self.image = UIImage(data: data!)
            }
        }.resume()
    }
}
