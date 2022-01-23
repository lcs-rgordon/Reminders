//
//  TaskStore.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2021-01-24.
//

import Foundation

class TaskStore: ObservableObject {

    // MARK: Stored properties
    @Published var tasks: [Task]
    
    // MARK: Initializer(s)
    init(tasks: [Task] = []) {
        self.tasks = tasks
    }
    
    // MARK: Functions
    
    // Return a list of tasks filtered based on criteria provided
    func filteredTasks(includingCompletedTasks: Bool) -> [Task] {
        
        if includingCompletedTasks {
            
            // Return all tasks
            return tasks
            
        } else {
            
            // Create an empty list
            var onlyIncompleteTasks: [Task] = []
            
            // Iterate over the existing list of tasks
            for currentTask in tasks {
                
                // Add incomplete tasks to the new list
                if currentTask.completed == false {
                    onlyIncompleteTasks.append(currentTask)
                }
                
            }
            
            // Return the list of incomplete tasks
            return onlyIncompleteTasks
            
        }
        
    }
    
}

var testStore = TaskStore(tasks: testData)
