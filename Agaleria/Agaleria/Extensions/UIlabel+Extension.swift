//
//  UIlabel+Extension.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 03/06/2022.
//

import Foundation

import UIKit

extension UILabel{
    
    func configureLabelWith(color: UIColor, text: String, size: CGFloat) {
        self.text = text
        textColor = color
        font = UIFont (name: FONT.regular, size: size)
    }
}
