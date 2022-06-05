//
//  PictureViewModel.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import Foundation

//MARK: - ViewModel Protocol Methods
protocol PicturesViewModelProtocol: AnyObject {
    func updateViewWithData()
    func updateViewWithError(errorMsg: String)
}

class PicturesViewModel {
    //MARK: - Data Members
    var page = 1
    var pictures: Picture?
    weak var delegate: PicturesViewModelProtocol?
    private var managerService: PicturesManagerServiceProtocol
      
    //MARK: - Init() with dependency
    init(managerService: PicturesManagerServiceProtocol = PicturesManagerService()) {
        self.managerService = managerService
    }
    
    
    //MARK: - Fetch Pictures Request to Managers
    func fetchPictures() {
        
        managerService.fetchPicturesData(page: self.page, limit: CONST.PAGE_LIMIT, completion: { [weak self] (picturesModel: Picture?, error: String?) in
            
            
            if let errorMsg = error, let pictures = picturesModel {
                if errorMsg == CONST.OFFLINE{
                    self?.pictures = pictures
                    self?.delegate?.updateViewWithError(errorMsg: CONST.OFFLINE)
                }
                return
            }

            if let pictures = picturesModel {
                if self?.page == 1{
                    self?.pictures = pictures
                }else{
                    self?.pictures! += pictures
                }
                self?.page += 1
                self?.delegate?.updateViewWithData()

            }else{
                self?.delegate?.updateViewWithError(errorMsg: error ?? K.SOMETHING_WENT_WRONG)
            }
            
        })
    }
}


