//
//  Picture.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import Foundation

struct PictureElement: Codable {
    var id, author: String
    var width, height: Int
    var url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

typealias Picture = [PictureElement]
