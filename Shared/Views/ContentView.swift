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
    @State private var showingCompletedTasks = true
    
    var body: some View {
        List {
            ForEach(store.filteredTasks(includingCompletedTasks: showingCompletedTasks)) { task in
                TaskCell(task: task,
                         completedTaskVisibility: $showingCompletedTasks)
            }
            // View modifier invokes the function
            .onDelete(perform: deleteItems)
            .onMove(perform: moveItems)
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
                    withAnimation {
                        showingCompletedTasks.toggle()
                    }
                    print("Value of showingCompletedTasks is now: \(showingCompletedTasks)")
                }
                
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTask(store: store, showing: $showingAddTask)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        // "offsets" contains a set of items selected for deletion
        // The set is then passed to the built-in "remove" method on
        // the "tasks" array which handles removal from the array
        store.tasks.remove(atOffsets: offsets)
    }
    
    // Invoked to move items around in our list, to set priority
    // See: https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-move-rows-in-a-list
    func moveItems(from source: IndexSet, to destination: Int) {
        store.tasks.move(fromOffsets: source, toOffset: destination)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(store: testStore)
        }
    }
}
