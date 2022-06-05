//
//  UIImageView+Extension.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 03/06/2022.
//

import Foundation
import UIKit
import CoreImage
let imageCache = NSCache<AnyObject, AnyObject>()
let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

extension UIImageView {
    func loadRemoteImageFrom(urlString: String){
        let url = URL(string: urlString)
        image = nil
        activityView.center = self.center
        self.addSubview(activityView)
        activityView.startAnimating()
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            return
        }
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url!) {
                data, response, error in
                DispatchQueue.main.async {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                }
                if let response = data {
                    DispatchQueue.main.async {
                        if let imageToCache = UIImage(data: response) {
                            let image = imageToCache.resizeImage()
                            imageCache.setObject(image, forKey: urlString as AnyObject)
                            self.image = image
                        }else{
                            self.image = UIImage(named: "placeHolder")
                        }
                    }
                }
            }.resume()
        }
        
    }
}
