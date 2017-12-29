//
//  Analytics.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation

struct Analytics {
    
    let Consumers: [Consumer]
    
    private let formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var successful: Int {
        return Consumers
            .map { $0.successful }
            .reduce(0,+)
    }
    
    var failed: Int {
        return Consumers
            .map { $0.failed }
            .reduce(0,+)
    }
    
    var queued: Int {
        return Consumers
            .map { $0.queued }
            .reduce(0, +)
    }
    
    var formattedSuccessful: String {
        return formatter.string(from: NSNumber(integerLiteral: successful)) ?? ""
    }
    
    var formattedFailed: String {
        return formatter.string(from: NSNumber(integerLiteral: failed)) ?? ""
    }
    
}
