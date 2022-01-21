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
        
        List(store.filteredTasks(with: TaskPriority.high.rawValue, includingCompletedTasks: true)) { task in
            TaskCell(task: task)
        }
        .navigationTitle("Important")
        
    }
}

struct ImportantTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImportantTasksView(store: testStore)
        }
    }
}
