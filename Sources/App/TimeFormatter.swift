//
//  TimeFormatter.swift
//  App
//
//  Created by John Connolly on 2018-01-09.
//

import Foundation

struct TimeFormatter {
    
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    private let format: Format
    
    enum Format {
        case long
        case medium
        case short
    }
    
    init(_ seconds: Int, with format: Format = .short) {
        self.format = format
        self.days = (seconds / 86_400)
        self.hours = (seconds % 86_400) / 3600
        self.minutes = (seconds % 3600) / 60
        self.seconds = (seconds % 3600) % 60
    }
    
    var formatted: String {
        if days > 1 {
            return String(days) + " days"
        } else if hours > 1 {
            return String(hours) + " Hours"
        } else if minutes > 1 {
            return String(minutes) + " Minutes"
        }
        return String(seconds) + " Seconds"
    }
    
    
}
