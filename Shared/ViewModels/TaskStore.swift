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
        
        // This property observer will fire when a task is added or deleted
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
    
    // MARK: Functions
    
    // Return a list of tasks that has the selected priority level
    func filteredTasks(with priorityLevel: String) -> [Task] {
        
        if priorityLevel == noSpecifiedPriorityLevel {
            
            // Return all the tasks
            return tasks
            
        } else {
            
            // Create an empty list of tasks that match the search term
            var matchingTasks: [Task] = []
            
            // Translate the given priority level (as a string) back into an enumeration value
            var givenPriority = TaskPriority.low
            switch priorityLevel {
            case TaskPriority.low.rawValue:
                givenPriority = TaskPriority.low
            case TaskPriority.medium.rawValue:
                givenPriority = TaskPriority.medium
            case TaskPriority.high.rawValue:
                givenPriority = TaskPriority.high
            default:
                break
            }
            
            // Iterate through all the tasks
            for task in tasks {
                
                // ... but when a priority level is specified...
                if task.priority == givenPriority {
                    
                    // ... only add tasks that match that priority level to the list that is returned
                    matchingTasks.append(task)
                }
                
            }
            
            // Return the list of matching tasks
            return matchingTasks

        }
        
    }

    // Delete items from the "tasks" list
    func deleteItems(at offsets: IndexSet) {
        // "offsets" contains a set of items selected for deletion
        // The set is then passed to the built-in "remove" method on the "tasks" array
        // which handles removal from the array
        tasks.remove(atOffsets: offsets)
    }
    
    // Delete provided task from the "tasks" list
    func delete(_ taskToDelete: Task) {
        tasks.removeAll(where: { currentTask in
            currentTask.id == taskToDelete.id
        })
    }
    
}

var testStore = TaskStore(tasks: testData)
