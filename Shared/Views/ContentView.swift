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
    
    // Whether to show completed tasks or not
    @State var showingCompletedTasks = true
    
    // Whether to re-compute the view to show changes the list
    // We never actually show this value, but toggling it
    // from "true" to "false" or vice-versa makes SwiftUI update
    // the user interface, since a property marked with @State has
    // changed
    @State var listShouldUpdate = false
    
    var body: some View {
        
        // DEBUG: What is the current value of this property?
        let _ = print("listShouldUpdate == \(listShouldUpdate)")
        
        List {
            ForEach(store.tasks) { task in
                if showingCompletedTasks {
                    // Show all tasks
                    TaskCell(task: task,
                             triggerListUpdate: .constant(true))
                } else {
                    // Only show incomplete tasks
                    if task.completed == false {
                        TaskCell(task: task,
                                 triggerListUpdate: $listShouldUpdate)
                    }
                }
            }
            // View modifier invokes the function
            .onDelete(perform: store.deleteItems)
            .onMove(perform: store.moveItems)
        }
        .navigationTitle("Reminders")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                    showingAddTask = true
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            
            ToolbarItem(placement: .bottomBar) {
                
                Button(showingCompletedTasks ? "Hide Completed Tasks" : "Show Completed Tasks") {
                    print("Value of showingCompletedTasks was: \(showingCompletedTasks)")
                    showingCompletedTasks.toggle()
                    print("Value of showingCompletedTasks is now: \(showingCompletedTasks)")
                }
                
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTask(store: store, showing: $showingAddTask)
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
