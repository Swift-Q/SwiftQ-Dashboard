//
//  FailedTaskView.swift
//  App
//
//  Created by John Connolly on 2018-01-09.
//

import Foundation

struct FailedTaskView: Codable {
    
    let name: String
    let consumer: String
    let error: String
    let enqueued: String
    let errorAt: String
    
    init(_ task: FailedTask) {
        self.name = task.storage.name
        self.consumer = task.storage.log.consumer
        self.error = task.storage.log.message
        self.enqueued = task.enqueued
        self.errorAt = task.errorAt
    }
}
