//
//  ContentView.swift
//  Shared
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

struct ContentView: View {

    // MARK: Stored properties
    // Stores all tasks that are being tracked
    @ObservedObject var store: TaskStore
    
    // Controls whether the add task is showing
    @State private var showingAddTask = false
    
    // What to filter upon
    @State private var selectedPriorityLevel = noSpecifiedPriorityLevel
    
    // MARK: Computed properties
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

            List {
                
                ForEach(store.filteredTasks(with: selectedPriorityLevel)) { task in
                    TaskCell(task: task)
                        .contextMenu {

                            // Purge this set of dice
                            Button(action: {
                                withAnimation {
                                    store.delete(task)
                                }
                            }) {
                                #if os(macOS)
                                Text("\(Image(systemName: "trash.fill"))\tDelete")
                                    .foregroundColor(.red)
                                #else
                                Label("Delete", systemImage: "trash.fill")
                                #endif
                            }

                        }
                }
                // View modifier invokes the function
                .onDelete(perform: deleteItems)

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
                // We only need the sheet inside a NavigationView on iOS
                #if os(iOS)
                NavigationView {
                    AddTask(store: store, showing: $showingAddTask)
                }
                #else
                AddTask(store: store, showing: $showingAddTask)
                #endif
            }
            
        }

    }
    
    // MARK: Functions
    func deleteItems(at offsets: IndexSet) {
        // "offsets" contains a set of items selected for deletion
        // The set is then passed to the built-in "remove" method on the "tasks" array
        // which handles removal from the array
        store.tasks.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(store: testStore)
        }
    }
}
