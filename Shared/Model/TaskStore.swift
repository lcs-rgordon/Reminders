//
//  TaskStore.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2021-01-24.
//

import Foundation

class TaskStore: ObservableObject {

    // MARK: Stored properties
    @Published var tasks: [Task] {
        
        // This property observer will fire when a task is added
        // The existence of this property observer ensures tasks are saved when the app is quit
        didSet {
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(tasks) {
                
                // DEBUG
                print("Saving tasks list now...")
                
                // Actually save the task
                UserDefaults.standard.setValue(encoded, forKey: "tasks")
                
            }
            
        }
        
    }
    
    // MARK: Initializer
    init(tasks: [Task] = []) {
        
        // Try to read the existing tasks from the app bundle
        if let readItems = UserDefaults.standard.data(forKey: "tasks") {
            
            let decoder = JSONDecoder()
            
            // Try to decode the items from JSON
            // Decodes an instance of the specified type
            // .self is required to reference the type objecct
            // So by saying [Task].self we are saying "decode the data from readItems into a structure of type [Task]"
            if let decoded = try? decoder.decode([Task].self, from: readItems) {
                self.tasks = decoded
            } else {
                self.tasks = []
            }
            return

        } else {
            
            // If nothing could be loaded from the app bundle, or data could not be decoded, show whatever reminders were passed in to the initializer
            self.tasks = tasks
            
        }
    }
}

var testStore = TaskStore(tasks: testData)
