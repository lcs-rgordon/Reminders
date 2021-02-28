//
//  ImportantTasksView.swift
//  Shared
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

struct ImportantTasksView: View {
    
    // Stores all tasks that are being tracked
    @ObservedObject var store: TaskStore
    
    var body: some View {
        
        List(store.filteredTasks(with: TaskPriority.high.rawValue)) { task in
            TaskCell(task: task)
        }
        .navigationTitle("Important")
        // When the app is quit or backgrounded, this closure will run
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            
            // Save the list of tasks
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(store.tasks) {
                print("Saving tasks list now, app has been backgrounded or quit...")
                // Actually save the tasks to UserDefaults
                UserDefaults.standard.setValue(encoded, forKey: "tasks")
            }
            
        }
        
    }
}

struct ImportantTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImportantTasksView(store: testStore)
        }
    }
}
