//
//  Consumer.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation

struct Consumer {
    
    let name: String
    let successful: Int
    let failed: Int
    let queued: Int
    
    private let formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    init(name: String, results: [String?]) {
        self.name = name
        let integers = results.flatMap { Int($0 ?? "0") }
        self.successful = integers[safe: 0] ?? 0
        self.failed = integers[safe: 1] ?? 0
        self.queued = 0
    }
    
    var formattedSuccessful: String {
        return formatter.string(from: NSNumber(integerLiteral: successful)) ?? ""
    }
    
    var formattedFailed: String {
        return formatter.string(from: NSNumber(integerLiteral: failed)) ?? ""
    }
    
    
}

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
    
}
