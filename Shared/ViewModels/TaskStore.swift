//
//  TaskStore.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2021-01-24.
//

import Foundation

class TaskStore: ObservableObject {

    // MARK: Stored properties
    
    // All tasks
    @Published var tasks: [Task]
    
    // Only incomplete tasks
    @Published var incompleteTasks: [Task] = []
    
    // Whether to show completed tasks or not
    @Published var showingCompletedTasks = true {
        
        // This closure will run just after the property "showingCompletedTasks" is changed
        willSet {
            
            // When completed tasks are no longer being shown,
            // we need to rebuild the list of incomplete tasks
            if newValue == false {
                
                rebuildIncompleteTasksList()
                
            }
        }
        
    }
    
    // What tasks are visible right now
    var visibleTasks: [Task] {
        if showingCompletedTasks {
            return tasks
        } else {
            return incompleteTasks
        }
    }
    
    // MARK: Initializer(s)
    init(tasks: [Task] = []) {
        self.tasks = tasks
    }
    
    // MARK: Functions
    func deleteItems(at offsets: IndexSet) {
        // "offsets" contains a set of items selected for deletion
        // The set is then passed to the built-in "remove" method on
        // the "tasks" array which handles removal from the array
        
        // We only need to work with the main list (all tasks) when showing completed tasks
        if showingCompletedTasks {
            tasks.remove(atOffsets: offsets)
        } else {
            
            // When showing incomplete tasks only... we must delete from the main list then regenerate the incomplete tasks list.
            // The issue is that user is seeing only tasks from the "incompleteTasks" list.
            // So, the offsets that iOS is providing for us work against the incomplete tasks list only.
            // We can work around this...
            // Iterate over list of items to be deleted...
            for offset in offsets {
                
                // Get the unique id of the item to be deleted
                let idOfTaskToDelete = incompleteTasks[offset].id
                
                // Now iterate over the list of all tasks and delete the item with this id
                for (index, currentTask) in tasks.enumerated() {
                    if currentTask.id == idOfTaskToDelete {
                        tasks.remove(at: index)
                        // Stop iterating over the "tasks" list since we found what needed to be removed
                        break
                    }
                }
                
            }
            
            // Now we need to regenerate the incomplete tasks list
            rebuildIncompleteTasksList()
        }
    }
    
    // Invoked to move items around in our list, to set priority
    // See: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-move-rows-in-a-list
    func moveItems(from source: IndexSet, to destination: Int) {
        
        // We only need to work with the main list (all tasks) when showing completed tasks
        if showingCompletedTasks {
            tasks.move(fromOffsets: source, toOffset: destination)
        }
        
    }
    
    // Rebuild the list of incomplete tasks
    private func rebuildIncompleteTasksList() {
        
        // Reset the list of incomplete tasks
        incompleteTasks = []
        
        // Iterate over the existing list of tasks
        for currentTask in tasks {
            
            // Add incomplete tasks to the new list
            if currentTask.completed == false {
                incompleteTasks.append(currentTask)
            }
            
        }

    }

        
}

var testStore = TaskStore(tasks: testData)
