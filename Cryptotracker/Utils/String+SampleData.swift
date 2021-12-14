//
//  String+SampleData.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 30/11/21.
//

import UIKit

extension String {
    func toData() -> Data {
        guard let url = Bundle.main.url(forResource: self, withExtension: "json") else {
            fatalError("Error to find json file: \(self)")
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Error to parse JSON: \(error)")
        }
        
    }
}
