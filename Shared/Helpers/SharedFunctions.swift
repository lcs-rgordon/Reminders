//
//  SharedFunctions.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2022-01-23.
//

import Foundation

// Return the directory that we can save user data in
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// Define a file that we will write to
let savedTasksLabel = "savedTasks"
