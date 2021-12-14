//
//  Models.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 04/11/21.
//

import Foundation

struct Crypto: Decodable {
    let assetId: String?
    let name: String?
    let price: Double?
    
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case name = "name"
        case price = "price_usd"
    }
    
//    func SnakeCaseDecoder() {
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//    }
    
}


struct Icon: Codable {
    let assetId: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case assetId = "asset_id"
    }
}
