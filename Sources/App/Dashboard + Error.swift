//
//  Dashboard + Error.swift
//  App
//
//  Created by John Connolly on 2018-01-04.
//

import Foundation

func handle(_ function: () throws -> ()) {
    do { try function() } catch { print(error) }
}

func handle<T>(_ function: () throws -> (T)) -> T? {
    do {
        return try function()
    } catch {
        print(error)
        return nil
        
    }
}
