//
//  AgaleriaTests.swift
//  AgaleriaTests
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import XCTest
@testable import Agaleria

class AgaleriaTests: XCTestCase {
    
    private var sut: PicturesViewModel!
    private var pictureManagerService: MockPictureManagerService!
    private var viewModel: MockPictureViewModel!
    
    private var apiClient: APIClient!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = MockPictureViewModel()
        pictureManagerService = MockPictureManagerService()
        sut = PicturesViewModel(managerService: pictureManagerService)
        sut.delegate = viewModel
        
        apiClient = APIClient()
        try super.setUpWithError()
        
    }
    
    override func tearDownWithError() throws {
        pictureManagerService = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_pictureViewModelWithData() throws {
        
        let picture = PictureElement(id: "0", author: "Alejandro Escamilla", width: 5616, height: 3744, url: "https://unsplash.com/photos/yC-Yzbqy7PY", downloadURL: "https://picsum.photos/id/0/5616/3744")
        
        pictureManagerService.pictureResponse = [picture]
        
        sut.fetchPictures()
        
        XCTAssertEqual(viewModel.picturesModel.count, 1)
        XCTAssertEqual(viewModel.picturesModel[0].author, "Alejandro Escamilla")
        XCTAssertEqual(viewModel.picturesModel[0].downloadURL, "https://picsum.photos/id/0/5616/3744")
        
    }
    
    func test_GetPicturesList() {
        
        let expectation = self.expectation(description: "getPicturesList")
        let params = [K.PAGE: String(1),
                      K.LIMIT: String(10) ]
        apiClient.sendRequest(parameters: params, completion: { (picturesModel: Picture?, error: String?) in
            
            XCTAssertNil(picturesModel) 
            expectation.fulfill()

        })
        
        waitForExpectations(timeout: 10, handler: nil)

    }
}

class MockPictureManagerService: PicturesManagerServiceProtocol  {
    
    var pictureResponse: Picture?
    func fetchPicturesData<T>(page: Int, limit: Int, completion: @escaping (T?, _ error: String?)->()) where T: Codable {
        
        if let pictureResponse = pictureResponse {
            completion(pictureResponse as? T, nil)
        }
    }
    
}


class MockPictureViewModel: PicturesViewModelProtocol {
    var picturesModel: [PictureElement] = []
    func updateViewWithData() {
        let picture = PictureElement(id: "0", author: "Alejandro Escamilla", width: 5616, height: 3744, url: "https://unsplash.com/photos/yC-Yzbqy7PY", downloadURL: "https://picsum.photos/id/0/5616/3744")
        picturesModel.append(picture)
    }
    
    func updateViewWithError(errorMsg: String) {
        
    }
    
    
}
