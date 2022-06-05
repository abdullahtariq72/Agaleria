//
//  PictureTableViewCell.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import UIKit
import Kingfisher


//MARK: - TableCell Protocol Methods
protocol PictureTableViewCellProtocol: AnyObject{
    
    func didShareButtonTap(index: Int)
    func didDownloadButtonTap(index: Int)
    func didTapOnImage(index: Int)
}

class PictureTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var pictureAuthodLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    
    //MARK: - DataMemebers
    weak var delegate: PictureTableViewCellProtocol?
    var currentIndex: Int!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pictureImageView.image = nil
    }
    
    //MARK: - setting up views / action / data
    func configure(model: PictureElement) {
        setUpViews()
        setUpActions()
        setUpDataInViews(from: model)
        
    }
    
    //MARK: - setting up subviews views
    func setUpViews(){
        bgView.shadowView()
        pictureImageView.roundUpperCorner(cornerRadius: CONST.CORNER_RADIUS)
        shareBtn.setTitle("", for: .normal)
        downloadBtn.setTitle("", for: .normal)
        shareBtn.tintColor = Colors.APP_ACCENT_COLOR
        downloadBtn.tintColor = Colors.APP_ACCENT_COLOR
    }
    
    //MARK: - setting up actions
    func setUpActions(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pictureImageView.isUserInteractionEnabled = true
        pictureImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: - setting up data in views
    func setUpDataInViews(from model: PictureElement){
        DispatchQueue.main.async {
            self.pictureAuthodLabel.configureLabelWith(color: .label, text:  model.author, size: FONT_SIZE.medium)
            self.pictureImageView.kf.indicatorType = .activity
            let processor = DownsamplingImageProcessor(size: self.pictureImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: CONST.CORNER_RADIUS)
            self.pictureImageView.kf.setImage(
                with: URL(string: model.downloadURL),
                placeholder: UIImage(named: "placeHolder"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
        }
    }
    
    //MARK: - Click Actions
    @IBAction func action_downloadImage(_ sender: Any) {
        self.delegate?.didDownloadButtonTap(index: self.currentIndex)
    }
    @IBAction func action_shareImage(_ sender: Any) {
        self.delegate?.didShareButtonTap(index: self.currentIndex)   
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.delegate?.didTapOnImage(index: self.currentIndex)
    }
}
