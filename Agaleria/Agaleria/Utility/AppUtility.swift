//
//  AppUtility.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 04/06/2022.
//

import Foundation
import UIKit
import Kingfisher

class AppUtility: NSObject {
    
    static var sharedInstance = AppUtility()
    
    static let keyWindow = UIApplication.shared.connectedScenes
        .lazy
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?
        .windows
        .first { $0.isKeyWindow }
    
    //MARK: - Share Image Activity
    func showShareActivity(image:UIImage, on: UIViewController){
        
        let compressedImage = image.resizeImage()
        let activityViewController =
            UIActivityViewController(activityItems: [compressedImage],
                                     applicationActivities: nil)

        on.present(activityViewController, animated: true)
    }
    
    //MARK: - Savr Image to Photos
    func saveToPhotos(image: UIImage, completion: @escaping (String?) -> ()) {
        ImageService().addToPhotos(image: image, completion: { result in
            completion(result)
        })
    }
    
    
    //MARK: - Get Cached Images
    func reteriveCachedImage(key: String, completion: @escaping (UIImage?) -> ()) {
        var image: UIImage? = nil
        ImageCache.default.retrieveImage(forKey: key) { result in
            switch result {
            case .success(let value):
                image = value.image ?? nil
                completion(image)
            case .failure( _):
                image = nil
                completion(image)
            }
        }
    }
    
}


struct ImageService {
    final class Delegate: NSObject {
        let completion: (String?) -> Void
        
        init(completion: @escaping (String?) -> Void) {
            self.completion = completion
        }
        
        @objc func savedImage(
            _ im: UIImage,
            error: String?,
            context: UnsafeMutableRawPointer?
        ) {
            DispatchQueue.main.async {
                if let error = error {
                    self.completion(error)
                } else {
                    self.completion("Success")
                }
            }
        }
    }
    
    func addToPhotos(image: UIImage, completion: @escaping (String?) -> Void) {
        let delegate = Delegate(completion: completion)
        UIImageWriteToSavedPhotosAlbum(
            image,
            delegate,
            #selector(Delegate.savedImage(_:error:context:)),
            nil
        )
    }
}
