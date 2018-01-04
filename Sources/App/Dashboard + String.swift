//
//  Dashboard + String.swift
//  App
//
//  Created by John Connolly on 2018-01-04.
//

import Foundation

extension String {
    
    /// Parses a string in the redis stats format into
    /// a key value pair.
    func parseStats() -> [String: String] {
        var results: [String : String] = [:]
        var currentField = "".unicodeScalars
        
        var key = "".unicodeScalars
        var value = "".unicodeScalars
        
        var newSection = false
        for char in self.unicodeScalars {
            switch char {
            case "\n":
                guard !newSection else {
                    newSection = false
                    break
                }
                
                value.append(contentsOf: currentField)
                currentField.removeAll()
                results[String(key)] = String(value)
                key.removeAll()
                value.removeAll()
            case ":":
                key.append(contentsOf: currentField)
                currentField.removeAll()
            case "#":
                newSection = true
            default:
                guard !newSection else {
                    break
                }
                currentField.append(char)
            }
        }
        return results
    }
}

extension String {
    
    private static let digits = UnicodeScalar("0")..."9"
    
    var digits: String {
        return String(unicodeScalars.filter { String.digits ~= $0 })
    }
    
}
