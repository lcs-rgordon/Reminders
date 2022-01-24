//
//  ImportantTasks.swift
//  Reminders
//
//  Created by Russell Gordon on 2022-01-24.
//

import SwiftUI

struct ImportantTasks: View {
    
    // Connection to the view model to retrieve data
    @ObservedObject var store: TaskStore
    
    var body: some View {
        
        List(store.tasks) { task in
            if task.priority == .high {
                TaskCell(task: task,
                         triggerListUpdate: .constant(true))
            }
        }
        .navigationTitle("Important")
        
    }
}

struct ImportantTasks_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImportantTasks(store: testStore)
        }
    }
}
