//
//  Constants.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 04/11/21.
//

import Foundation

struct Constants {
    static let apiKey = "A38643EE-A9E1-48AC-AB9E-041F4992AE2A"
    static let assetsBaseUrl = "https://rest.coinapi.io/v1/assets"
    static let size = 50
    static let assetsIconsUrl = "\(Constants.assetsBaseUrl)/icons/\(Constants.size)"
    
    static var baseURL: URL {
        guard let url = URL(string: Constants.assetsBaseUrl) else {
            fatalError("Error to create url")
        }
        
        return url
    }
    
    static var baseIconsURL: URL {
        guard let url = URL(string: Constants.assetsIconsUrl) else {
            fatalError("Error to create url")
        }
        
        return url
    }
    
    struct Headers {
        static var contentTypeApplicationJSON = ["Content-Type": "application/json"]
    }
    
    //struct Path { }
}


//extension Constants.Path {
//    static var internalPath = ""
//}

//Constants.Path.internalPath
