//
//  SplashViewController.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var gifAnimationView: AnimationView!
    
    // MARK: - ViewLoading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpNavigateGalleryListViewController()
    }
    
    // MARK: - Change Navigation to Pictures List
    func setUpNavigateGalleryListViewController(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let picturesListVC = Storyboards.MAIN.instantiateViewController(withIdentifier: Controllers.PICTURESLIST)
            self.navigationController?.pushViewController(picturesListVC, animated: true)
            
        }
    }
    
    // MARK: - SetupControllerViews
    func setUpViews(){
        self.navigationController?.navigationBar.isHidden = true
        configureLottieAnimation()
    }
    
    // MARK: - SetupAnimationLogo
    func configureLottieAnimation(){
        let animation = Animation.named("cameraAnimate")
        gifAnimationView.contentMode = .scaleAspectFill
        gifAnimationView.animation = animation
        gifAnimationView.loopMode = .loop
        gifAnimationView.play()
    }
}
