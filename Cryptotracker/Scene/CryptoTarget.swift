//
//  CryptoTarget.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 16/11/21.
//

import Foundation
import Moya

enum CryptoTarget: TargetType {
    case loadCryptos
    case loadImages
    
    var baseURL: URL {
        switch self {
        case .loadCryptos:
            return Constants.baseURL
        case .loadImages:
            return Constants.baseIconsURL
        }
    }
    
    var path: String {
        ""
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        .requestParameters(parameters:
                            ["apikey": Constants.apiKey],
                           encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        Constants.Headers.contentTypeApplicationJSON
    }
    
    var sampleData: Data {
        switch self {
        case .loadCryptos:
            return "LoadCryptoSampleData".toData()
        case .loadImages:
            return "LoadIconsSampleData".toData()
        }
    }
    
    var validationType: ValidationType {
        .successCodes
//        switch self {
//        case .loadCryptos:
//            return .successCodes
//        case .loadImages:
//            return .customCodes([200, 410] + Array(210...250))
//        }
    }
}


//extension CryptoTarget: AccessTokenAuthorizable {
//    var authorizationType: AuthorizationType? {
//        return .bearer
//    }
//
//
//    static var authPlugin: AccessTokenPlugin {
//        return AccessTokenPlugin { target in
////            return "test-api-auth"
//            guard let cryptoTarget = target as? CryptoTarget else { return ""}
//            switch cryptoTarget {
//            case .loadCryptos:
//                return "custom-value"
//            case .loadImages:
//                return Constants.apiKey
//            }
//        }
//    }
//
//    static var availablePlugins: [PluginType] {
//        #if DEBUG
//        [authPlugin, NetworkLoggerPlugin()]
//        #else
//        [authPlugin]
//        #endif
//    }
//
//}
