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
//    var images = ["https://i.imgur.com/PEV86ZB.jpg", "https://i.imgur.com/JphcdPU.jpg", "https://i.imgur.com/Lh3baoP.jpg", "https://i.imgur.com/wFh2Ooe.jpg", "https://i.imgur.com/S25usBk.jpg", "https://i.imgur.com/AREHg68.jpg", "https://i.imgur.com/Ax1nVUD.jpg", "https://i.imgur.com/m3vP51I.jpg", "https://i.imgur.com/q0VKB9M.jpg", "https://i.imgur.com/xdCjJiH.jpg", "https://i.imgur.com/zJuqzwr.jpg", "https://i.imgur.com/jblrstS.jpg", "https://i.imgur.com/PdQhgPd.jpg", "https://i.imgur.com/kfuvrZX.jpg", "https://i.imgur.com/IREdMyU.jpg", "https://i.imgur.com/L4ZZdLJ.jpg", "https://i.imgur.com/zVJcFDV.jpg", "https://i.imgur.com/KMk9FrX.jpg", "https://i.imgur.com/ku8P1Q4.jpg", "https://i.imgur.com/cq9Ulx8.jpg", "https://i.imgur.com/TvjTMGY.jpg", "https://i.imgur.com/K0Ubc1u.jpg", "https://i.imgur.com/j4pJden.jpg", "https://i.imgur.com/NKKJcAa.jpg", "https://i.imgur.com/IrU9P1b.png", "https://i.imgur.com/Nutjyxu.jpg", "https://i.imgur.com/7PJhQkb.jpg", "https://i.imgur.com/EK2HDlE.jpg", "https://i.imgur.com/mUoPwbN.jpg", "https://i.imgur.com/QK6Iq5h.jpg", "https://i.imgur.com/loJQbr4.jpg", "https://i.imgur.com/q8LmXH1.jpg", "https://i.imgur.com/PEvkhL1.jpg", "https://i.imgur.com/ocpYvPd.jpg", "https://i.imgur.com/7gQfZ52.jpg", "https://i.imgur.com/8KPtuDL.jpg", "https://i.imgur.com/NHNG7Mp.jpg", "https://i.imgur.com/5POBeJm.jpg", "https://i.imgur.com/NN19DJz.jpg", "https://i.imgur.com/qkPl286.jpg", "https://i.imgur.com/O1Y9xne.jpg", "https://i.imgur.com/dAHFXw3.jpg", "https://i.imgur.com/XAXgT8r.jpg", "https://i.imgur.com/VBPzZ9K.jpg", "https://i.imgur.com/KBKYIvs.jpg", "https://i.imgur.com/9CxKM48.jpg", "https://i.imgur.com/aoVpuqB.jpg", "https://i.imgur.com/LCy1grt.jpg", "https://i.imgur.com/ifPotXk.jpg", "https://i.imgur.com/m57czaL.jpg", "https://i.imgur.com/xfF9km1.jpg", "https://i.imgur.com/AdYuhBk.jpg", "https://i.imgur.com/9T0esRO.jpg", "https://i.imgur.com/iJcWKMy.jpg", "https://i.imgur.com/xjGheez.jpg", "https://i.imgur.com/xetSFd4.jpg", "https://i.imgur.com/ANOqJg3.jpg", "https://i.imgur.com/CU0TkVg.jpg", "https://i.imgur.com/hQFydCP.jpg", "https://i.imgur.com/o4kDWex.jpg", "https://i.imgur.com/Ch8wo6J.jpg", "https://i.imgur.com/Gb4HWTF.jpg", "https://i.imgur.com/4FXvMmt.jpg", "https://i.imgur.com/cXfIpZh.jpg", "https://i.imgur.com/RsWgglt.jpg", "https://i.imgur.com/WFVOmLO.jpg", "https://i.imgur.com/OK0qAxv.jpg", "https://i.imgur.com/m0TB9Mw.jpg", "https://i.imgur.com/DdoSr2H.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImagesByName(name: "cats")
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! CollectionViewCell
        
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
                self.collectionView?.reloadData()
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}

