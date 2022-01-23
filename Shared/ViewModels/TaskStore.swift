//
//  TaskStore.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2021-01-24.
//

import Foundation

class TaskStore: ObservableObject {

    // All tasks
    @Published var tasks: [Task]
        
    // MARK: Initializer(s)
    init(tasks: [Task] = []) {
        self.tasks = tasks
    }
    
    // MARK: Functions
    
    // Invoked to delete items from our list
    func deleteItems(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    // Invoked to move items around in our list, to set priority
    // See: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-move-rows-in-a-list
    func moveItems(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
    
}

var testStore = TaskStore(tasks: testData)
