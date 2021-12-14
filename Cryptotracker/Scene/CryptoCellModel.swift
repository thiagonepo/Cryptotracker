//
//  CryptoCellModel.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 04/11/21.
//

import Foundation

struct CryptoCellModel {
    var name: String {
        crypto.name ?? "Not found"
    }
    
    var symbol: String {
        crypto.assetId ?? "Not found"
    }
    
    var price: String {
        crypto.price?.currency ?? "Not found"
    }
    
    var imageString: String {
        crypto.image ?? ""
    }
    
    private let crypto: Crypto
    
    init(crypto: Crypto) {
        self.crypto = crypto
    }
}
