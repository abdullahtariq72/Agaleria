//
//  Constants.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import Foundation
import UIKit


//MARK: CONST
struct CONST {
    static let PAGE_LIMIT = 10
    static let CORNER_RADIUS = 4.0
    static let REQUEST_CACHE = "REQUEST_CACHE"
    static let OFFLINE = "101"
}

//MARK: K - Constants
struct K {
    
    static let DEV_BASE_SERVER_URL = "https://picsum.photos/v2/list"
    static let SOMETHING_WENT_WRONG = "Something Went Wrong"
    static let NO_INTERNET = "You are currently offline"
    static let CONNECTED_INTERNET = "You conection is restored"
    static let PHOTO_SAVED = "Saved in Photo Library"
    static let PAGE = "page"
    static let LIMIT = "limit"
            
}

//MARK: Storyboards
struct Storyboards {
    static let MAIN = UIStoryboard(name: "Main", bundle: nil)
    
}

//MARK: NIB Files
struct NIBs {
    static let PictureCell = "PictureTableViewCell"
    static let ShimmerCell = "ShimmerCell"
    static let AlertView = "AlertView"
}

//MARK: Indentifiers
struct Indentifiers {
    static let PicturesCell = "PictureTableViewCell_Id"
    static let ShimmerCell = "ShimmerCell_Id"
}

//MARK: Controllers
struct Controllers {
    static let SPLASH = "SplashViewController"
    static let PICTURESLIST = "PicturesListVC"
    static let IMAGEVIEWERVC = "ImageViewerVC"
}

//MARK: FONT
struct FONT {
    static let regular = "Roboto-Regular"
    static let bold = "Roboto-Bold"
    static let light = "Roboto-Light"
    static let ultraLight = "Roboto-Thin"
    static let semiBold = "Roboto-Medium"
}

//MARK: FONT SIZE
struct FONT_SIZE {
    static let smallest:CGFloat = 12.0
    static let small:CGFloat = 13.0
    static let medium:CGFloat = 15.0
    static let large:CGFloat = 19.0
    static let buttonTitle:CGFloat = 14.0
    static let extraLarge:CGFloat = 22.0
    static let extraSmall : CGFloat = 7.8
    static let carTypeFontSize: CGFloat = 11
    static let carTimeLabelSize :CGFloat = 10
    static let serviceNameFontSize : CGFloat = 17.0
    static let priceFontSize : CGFloat = 16.0
    static let textfieldSize: CGFloat = 18
    static let superLarge: CGFloat = 27.0
    static let maxFontSize: CGFloat = 36.0
    static let navigationTitleTextSize: CGFloat = 19
}

//MARK: Colors
struct Colors {
    static let APP_ACCENT_COLOR = #colorLiteral(red: 0.003921568627, green: 0.6823529412, blue: 0.5529411765, alpha: 1)
    static let WHITE_COLOR = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let BLACK_COLOR = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let FULL_BLACK_COLOR = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
}
