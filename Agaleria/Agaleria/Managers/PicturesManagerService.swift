//
//  APINetworkService.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import Foundation

//MARK: - PicturesManagerService Protocol Methods
protocol PicturesManagerServiceProtocol: AnyObject {
    func fetchPicturesData<T>(page: Int, limit: Int, completion: @escaping (T?, _ error: String?)->()) where T: Codable
}

class PicturesManagerService {
    
    //MARK: - Data Members
    private var apiClient: APIClientProtocol
    private let requestCache = NSCache<AnyObject, AnyObject>()
    
    //MARK: - Init() with dependency
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
}


//MARK: - Fetch Pictures Request to API Client
extension PicturesManagerService: PicturesManagerServiceProtocol {
    
    func fetchPicturesData<T>(page: Int, limit: Int, completion: @escaping (T?, _ error: String?)->()) where T: Codable {
        
        if NetworkUtility.sharedInstance.reachability.connection == .unavailable{
            if let requestCache = requestCache.object(forKey: CONST.REQUEST_CACHE as AnyObject) as? Picture {
                completion(requestCache as? T, CONST.OFFLINE)
            }else{
                completion(nil, K.NO_INTERNET)
            }
            return
        }
        
        let params = [K.PAGE: String(page),
                      K.LIMIT: String(limit) ]
        apiClient.sendRequest(parameters: params, completion: { (picturesModel: T?, error: String?) in
            
            if let pictures = picturesModel {
                self.saveCacheRequest(pictures as? Picture)
                completion(pictures, nil)
            }else{
                completion(nil, error ?? K.SOMETHING_WENT_WRONG)
            }
            
        })
    }
    
    //MARK: - Save Request to Cache
    func saveCacheRequest(_ picture: Picture?){
        if let picture = picture{
            if let requestCache = requestCache.object(forKey: CONST.REQUEST_CACHE as AnyObject) as? Picture {
                var prevRequest = requestCache
                prevRequest += picture
                self.requestCache.setObject(prevRequest as AnyObject, forKey: CONST.REQUEST_CACHE as AnyObject)
            }else{
                self.requestCache.setObject(picture as AnyObject, forKey: CONST.REQUEST_CACHE as AnyObject)
            }
            
        }
        
    }
}
