//
//  ViewController.swift
//  SwiftGallery
//
//  Created by Leonardo on 06/09/19.
//  Copyright © 2019 Leonardo. All rights reserved.
//

import UIKit

let clientId = "1ceddedc03a5d71"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    var images = Array<String>()

    fileprivate func setupLayout() {
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.width)/4, height: (self.collectionView.frame.height)/6)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        fetchImagesByName(name: "cats")

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! CollectionViewCell

        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.image.loadImageUsingUrlString(urlString: self.images[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }

    func fetchImagesByName(name: String) -> Void {
        let url = URL(string: "https://api.imgur.com/3/gallery/search/?q=\(name)")
        var request = URLRequest(url: url!)
        request.setValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                let alertController = UIAlertController(title: "SwiftGallery", message: error?.localizedDescription ?? "Error loading images.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
                print(error?.localizedDescription ?? "Response error")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dictionary = json as! [String: AnyObject]
                let gallery = dictionary["data"] as! [[String: AnyObject]]
                for album in gallery {
                    if(album["is_album"]!.boolValue) {
                        let images = album["images"] as! [[String: AnyObject]]
                        for image in images {
                            if(!image["animated"]!.boolValue) {
                                let link = image["link"]!
                                self.images.append(link as! String)
                            }
                        }
                    }
                }
                print(self.images)
                print(self.images.count)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}

