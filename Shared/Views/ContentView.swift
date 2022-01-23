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
    
    // What priority of tasks to show
    @State private var selectedPriorityForVisibleTasks: VisibleTaskPriority = .all
    
    // Whether to re-compute the view to show changes the list
    // We never actually show this value, but toggling it
    // from "true" to "false" or vice-versa makes SwiftUI update
    // the user interface, since a property marked with @State has
    // changed
    @State var listShouldUpdate = false
    
    var body: some View {
        
        // DEBUG: What is the current value of this property?
        let _ = print("listShouldUpdate == \(listShouldUpdate)")
        
        VStack {
            
            Text("Filter by...")
                .font(Font.caption.smallCaps())
                .foregroundColor(.secondary)
            #if os(macOS)
                .padding(.top)
            #endif
            
            Picker("Priority", selection: $selectedPriorityForVisibleTasks) {
                Text(VisibleTaskPriority.all.rawValue).tag(VisibleTaskPriority.all)
                Text(VisibleTaskPriority.low.rawValue).tag(VisibleTaskPriority.low)
                Text(VisibleTaskPriority.medium.rawValue).tag(VisibleTaskPriority.medium)
                Text(VisibleTaskPriority.high.rawValue).tag(VisibleTaskPriority.high)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
                ForEach(store.tasks) { task in
                    if showingCompletedTasks {
                        // Show all tasks
                        if selectedPriorityForVisibleTasks == .all {
                            TaskCell(task: task,
                                     triggerListUpdate: .constant(true))
//                                .modifier(DeleteMenuItem(store: store, task: task)) // Ugly way
                                .deleteMenuItem(store: store, task: task)           // Nice way with extension to View
                        } else {
                            if task.priority.rawValue == selectedPriorityForVisibleTasks.rawValue {
                                TaskCell(task: task,
                                         triggerListUpdate: .constant(true))
                                    .deleteMenuItem(store: store, task: task)
                            }
                        }
                    } else {
                        // Only show incomplete tasks
                        if task.completed == false {
                            
                            if selectedPriorityForVisibleTasks == .all {
                                TaskCell(task: task,
                                         triggerListUpdate: $listShouldUpdate)
                                    .deleteMenuItem(store: store, task: task)

                            } else {
                                if task.priority.rawValue == selectedPriorityForVisibleTasks.rawValue {
                                    TaskCell(task: task,
                                             triggerListUpdate: $listShouldUpdate)
                                        .deleteMenuItem(store: store, task: task)
                                }
                            }
                        }
                    }
                }
                // View modifier invokes the function
                .onDelete(perform: store.deleteItems)
                .onMove(perform: store.moveItems)
            }
        }
        .navigationTitle("Reminders")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            #endif
            
            #if os(iOS)
            ToolbarItem(placement: .bottomBar) {
                
                Button(showingCompletedTasks ? "Hide Completed Tasks" : "Show Completed Tasks") {
                    print("Value of showingCompletedTasks was: \(showingCompletedTasks)")
                    showingCompletedTasks.toggle()
                    print("Value of showingCompletedTasks is now: \(showingCompletedTasks)")
                }
                
            }
            #else
            ToolbarItem(placement: .automatic) {
                
                Button(showingCompletedTasks ? "Hide Completed Tasks" : "Show Completed Tasks") {
                    print("Value of showingCompletedTasks was: \(showingCompletedTasks)")
                    showingCompletedTasks.toggle()
                    print("Value of showingCompletedTasks is now: \(showingCompletedTasks)")
                }
                
            }
            #endif
            
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

struct DeleteMenuItem: ViewModifier {
    
    let store: TaskStore
    let task: Task
    
    func body(content: Content) -> some View {
        content
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
}

extension View {
    func deleteMenuItem(store: TaskStore, task: Task) -> some View {
        modifier(DeleteMenuItem(store: store, task: task))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(store: testStore)
        }
    }
}
