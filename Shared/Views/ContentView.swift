//
//  ContentView.swift
//  Shared
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

struct ContentView: View {
    
    // Stores all tasks that are being tracked
    @ObservedObject var store: TaskStore
    
    // Controls whether the add task is showing
    @State private var showingAddTask = false
    
    // What to filter upon
    @State private var selectedPriorityLevel = noSpecifiedPriorityLevel
    
    var body: some View {
        
        VStack {
            
            Text("Filter by...".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
            
            Picker("Priority", selection: $selectedPriorityLevel) {
                Text(noSpecifiedPriorityLevel).tag(noSpecifiedPriorityLevel)
                Text(TaskPriority.low.rawValue).tag(TaskPriority.low.rawValue)
                Text(TaskPriority.medium.rawValue).tag(TaskPriority.medium.rawValue)
                Text(TaskPriority.high.rawValue).tag(TaskPriority.high.rawValue)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            List(store.filteredTasks(with: selectedPriorityLevel)) { task in
                TaskCell(task: task)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        showingAddTask = true
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTask(store: store, showing: $showingAddTask)
            }
            
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(store: testStore)
        }
    }
}
