//
//  CryptoCellModelTests.swift
//  CryptoTrackerTests
//
//  Created by Thiago Nepomuceno Silva on 30/11/21.
//

import XCTest
@testable import Cryptotracker


class CryptoCellModelTests: XCTestCase {
    
    func test_price_expect_to_show_formattedCurrency() {
        let sut = makeSut(price: 10)
        
        XCTAssertEqual(sut.price, "$10.00")
    }
    
    func test_invalidPrice_expect_to_show_notFound() {
        let sut = makeSut(price: nil)
        
        XCTAssertEqual(sut.price, "Not found")
    }
    
    func test_invalidFields_expected_to_show_notFound() {
        let sut = makeSut(assetId: nil, name: nil, price: nil, image: nil)
        
        XCTAssertEqual(sut.name, "Not found")

        XCTAssertEqual(sut.price, "Not found")

        XCTAssertEqual(sut.symbol, "Not found")

        XCTAssertEqual(sut.imageString, "")
    }
    
    func makeSut(assetId: String? = "BTC", name: String? = "Bitcoin", price: Double? = 5700, image: String? = nil) -> CryptoCellModel {
        CryptoCellModel(crypto: Crypto(assetId: assetId,
                                       name: name,
                                       price: price,
                                       image: image))
        
        
    }
}
