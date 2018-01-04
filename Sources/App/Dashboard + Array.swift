//
//  Dashboard + Array.swift
//  App
//
//  Created by John Connolly on 2018-01-03.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
    
}
