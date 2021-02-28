//
//  TaskPriority.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2021-01-24.
//

import Foundation

enum TaskPriority: String, Decodable  {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}
