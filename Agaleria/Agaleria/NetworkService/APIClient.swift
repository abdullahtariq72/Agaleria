//
//  APIClient.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 03/06/2022.
//

import Foundation

//MARK: - APIClient Request Method
public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

//MARK: - APIClient Protocol Method
protocol APIClientProtocol: AnyObject {
    func sendRequest<T>(parameters: [String: String], completion: @escaping (T?, _ error: String?)->()) where T: Codable
}


class APIClient {
    
    //MARK: - DataMember
    let session: URLSession
    
    //MARK: - init() with dependency
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
}

//MARK: - API Request to get Pictures
extension APIClient: APIClientProtocol{
    
    func sendRequest<T>(parameters: [String: String], completion: @escaping (T?, _ error: String?)->()) where T: Codable {

        let urlString = K.DEV_BASE_SERVER_URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let urlString = urlString else {return}
        var components = URLComponents(string: urlString)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: components.url!)
        request.cachePolicy = .returnCacheDataDontLoad

        if NetworkUtility.sharedInstance.reachability.connection == .wifi || NetworkUtility.sharedInstance.reachability.connection == .cellular{
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
        request.httpMethod = RequestMethod.get.rawValue
        session.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                    DispatchQueue.main.async {
                        completion(decodedResponse, nil)
                    }
                    return
                }
            }
            completion(nil, error?.localizedDescription ?? K.SOMETHING_WENT_WRONG)
        }
        .resume()
    }
}
