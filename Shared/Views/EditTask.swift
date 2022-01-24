//
//  EditTask.swift
//  Reminders
//
//  Created by Russell Gordon on 2022-01-24.
//

import SwiftUI

struct EditTask: View {

    // The task that we will save to, eventually
    @ObservedObject var task: Task
    
    // Details of the task to be edited
    @State private var description = ""
    @State private var priority = TaskPriority.low

    // Whether to show this view
    @Binding var showing: Bool
    
    // The title of this sheet
    let title = "Edit Reminder"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            #if os(macOS)
            Text(title)
                .font(.title2)
                .bold()
            #endif
            
            Form {
                TextField("Description", text: $description)
                
                Picker("Priority", selection: $priority) {
                    Text(TaskPriority.low.rawValue).tag(TaskPriority.low)
                    Text(TaskPriority.medium.rawValue).tag(TaskPriority.medium)
                    Text(TaskPriority.high.rawValue).tag(TaskPriority.high)
                }
                .pickerStyle(.segmented)
                
            }
            
            // Push content up (helps on macOS)
            Spacer()
        }
        .task {
            description = task.description
            priority = task.priority
        }
        // Padding required on macOS to make things look better
        #if os(macOS)
        .padding()
        #endif
        .navigationTitle(title)
        .toolbar {
            
            #if os(iOS)
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    // Dismiss the sheet by adjusting the "showing"
                    // property, a derived value, which is bound
                    // to the "showingAddTask" property from
                    // ContentView, the source of truth
                    showing = false
                }
            }
            
            // Using .automatic for placement ensures button appears on macOS
            ToolbarItem(placement: .automatic) {
                Button("Save") {
                    saveTask()
                }
                // The button is disabled, and therefore cannot be
                // pressed, when the description of the task is empty.
                // This prevents the user from saving an empty task.
                .disabled(description.isEmpty)
            }
            #else
            ToolbarItem(placement: .automatic) {
                Button("Cancel") {
                    // Dismiss the sheet by adjusting the "showing"
                    // property, a derived value, which is bound
                    // to the "showingAddTask" property from
                    // ContentView, the source of truth
                    showing = false
                }
            }

            // Using .cancellationAction for placement ensures button appears on macOS
            ToolbarItem(placement: .cancellationAction) {
                Button("Save") {
                    saveTask()
                }
                // The button is disabled, and therefore cannot be
                // pressed, when the description of the task is empty.
                // This prevents the user from saving an empty task.
                .disabled(task.description.isEmpty)
            }

            #endif
        }
        // Prevents dismissal of the sheet by swiping down
        // If sheet is dismissed this way, data is not saved.
        // Better that user needs to press "Save" button or "Cancel"
        // button, so we know their intent when dismissing the sheet
        .interactiveDismissDisabled()
        
    }
    
    func saveTask() {
        
        // Update the task in the list of tasks
        // No need to append since the task already exists in the list
        // of tasks
        task.description = description
        task.priority = priority
        
        // Dismiss this view
        showing = false
        
    }

    
}

struct EditTask_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditTask(task: testData[0], showing: .constant(true))
        }
    }
}
