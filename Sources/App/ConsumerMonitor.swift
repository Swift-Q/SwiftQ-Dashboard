//
//  ConsumerMonitor.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation

final class ConsumerMonitor {
    
    private let source: DispatchSourceTimer
    
   
    init() {
        let queue = DispatchQueue(label: "com.monitor.SwifQ-Web")
        self.source = DispatchSource.makeTimerSource(queue: queue)
    }
    
    func run() {
        source.schedule(deadline: .now(), repeating: .seconds(1), leeway: .seconds(0))
        
        source.setEventHandler {
            
        }
        
        source.resume()
    }
    
    
    
}

