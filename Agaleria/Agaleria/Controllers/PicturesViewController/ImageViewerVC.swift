//
//  ImageViewerVC.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 04/06/2022.
//

import UIKit

class ImageViewerVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var mainContentView: UIView!
    
    
    //MARK: - DataMembers
    var modelImage: UIImage?
    var didDismissVC: (() -> Void)? = nil
    
    //MARK: - setting up viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //MARK: - setting up views
    func setUpViews(){
        let imageView = ImageViewZoom(frame: CGRect(x: 0, y: 0, width: mainContentView.frame.size.width, height: mainContentView.frame.size.height))
        imageView.backgroundColor = .clear
        if let modelImage = modelImage {
            imageView.display(image: modelImage)
        }
        imageView.setup()
        imageView.imageScrollViewDelegate = self
        imageView.imageContentMode = .aspectFit
        
        mainContentView.addSubview(imageView)
        
    }
    
    //MARK: - ZoomIn/ZoomOut handler
    @objc
    private func pincheGestureHandler(sender: UIPinchGestureRecognizer) {
        
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        guard let scale = scaleResult else { return }
        sender.view?.transform = scale
        sender.scale = 1
        
    }
    
    //MARK: - View Close Action
    @IBAction func action_closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.didDismissVC?()
        })
    }
}

//MARK: - ImageZoom Delegate Methods
extension ImageViewerVC: ImageViewZoomDelegate {
    func imageScrollViewDidChangeOrientation(imageViewZoom: ImageViewZoom) {
        print("Did change orientation")
        self.mainContentView.layoutIfNeeded()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}

