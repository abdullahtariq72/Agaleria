//
//  AlertView.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 04/06/2022.
//

import Foundation
import UIKit
let SCREEN_SIZE = UIScreen.main.bounds

class AlertView: UIView {
    //MARK: - IBOutlets
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    //MARK: - NIB Initiate
    override func awakeFromNib() {
        
        msgLabel.textColor = UIColor.white
        messageView.layer.cornerRadius = CONST.CORNER_RADIUS
        msgLabel.font = UIFont(name: FONT.regular, size: FONT_SIZE.small)
        self.messageView.transform = CGAffineTransform(translationX: 0, y: SCREEN_SIZE.height - 45)
        self.statusIcon.tintColor = UIColor.white

        
    }


    //MARK: - Show Message after Setting up views
    func showMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.messageView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            }, completion: { finished in
                self.perform(#selector(self.hideMessage), with: nil, afterDelay: 2.0)
            })
        })
    }
    
    //MARK: - Setting Up Message
    func setMessage(message:String, icon: UIImage) {
        self.messageView.backgroundColor = UIColor(named: "AlertViewBGColor")
        self.msgLabel.text = message
        self.statusIcon.image = icon
        self.showMessage()
    }
    
    //MARK: - Show Message to View
    static func showWith(message: String, icon: UIImage) {
        checkAndRemoveErrorViewIfAlreadyPresent()
        let subMsgView = UINib(nibName: NIBs.AlertView, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AlertView
        subMsgView.frame = CGRect(x: 0, y:  SCREEN_SIZE.height - 20 , width: SCREEN_SIZE.width, height: 45.0)
        AppUtility.keyWindow!.addSubview(subMsgView)
        subMsgView.setMessage(message: message, icon: icon)
    }

    //MARK: - Hidding Message
    @objc func hideMessage() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        UIView.animate(withDuration: 0.5, animations: {
            self.messageView.transform = CGAffineTransform(translationX: 0, y: self.messageView.frame.height)
        }, completion: { [weak self] finished in
            self?.removeFromSuperview()
        })
    }
    
    //MARK: - Remove Alertview if already present
    private static func checkAndRemoveErrorViewIfAlreadyPresent() {
        if let keyWindow = AppUtility.keyWindow {
            for tempSubview in keyWindow.subviews.reversed() {
                if let subView = tempSubview as? AlertView {
                    subView.removeFromSuperview()
                    return
                }
            }
        }
    }

}
