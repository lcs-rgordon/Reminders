//
//  TaskCell.swift
//  Reminders
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

struct TaskCell: View {
    
    @ObservedObject var task: Task
    
    @Binding var triggerListUpdate: Bool
    
    @State private var showingEditTask = false
        
    var taskColor: Color {
        switch task.priority {
        case .high:
            return Color.red
        case .medium:
            return Color.blue
        case .low:
            return Color.primary
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    
                    // Complete the task (or mark it incomplete)
                    task.completed.toggle()
                    
                    // Tell the list on the parent view it should update
                    withAnimation {
                        triggerListUpdate.toggle()
                    }
                    
                }
            
            Text(task.description)
                .onTapGesture(count: 2) {
                    
                    print("double tapped")
                    
                    // Show the Edit task window
                    showingEditTask = true
                    
                }
        }
        .foregroundColor(self.taskColor)
        .sheet(isPresented: $showingEditTask) {
            // We only need the sheet inside a NavigationView on iOS
            #if os(iOS)
            NavigationView {
                EditTask(task: task, showing: $showingEditTask)
            }
            #else
            EditTask(task: task, showing: $showingEditTask)
            #endif
        }

    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(task: testData[0], triggerListUpdate: .constant(true))
        TaskCell(task: testData[1], triggerListUpdate: .constant(true))
    }
}
