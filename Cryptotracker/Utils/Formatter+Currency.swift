//
//  Formatter+Currency.swift
//  CryptoTracker
//
//  Created by Thiago Nepomuceno Silva on 04/11/21.
//

import Foundation

extension Locale {
    static let us = Locale(identifier: "en_US")
    static let br = Locale(identifier: "pt_BR")
}


extension NumberFormatter {
    convenience init(style: Style, locale: Locale = .current) {
        self.init()
        numberStyle = style
        self.locale = locale
        formatterBehavior = .default
    }
}

extension Double {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter(style: .currency, locale: .us)
        formatter.allowsFloats = true
        formatter.maximumFractionDigits = 2
       return formatter
    }()
    
    var currency: String {
        Double.currencyFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
