//
//  TaskCell.swift
//  Reminders
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

struct TaskCell: View {
    
    @ObservedObject var task: Task
    
    // A derived value connected to a boolean on ContentView
    @Binding var triggerListUpdate: Bool
    
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
                    
                    // Toggle task completion status... this means:
                    //
                    // Complete the task (if it was previously incomplete)
                    // or
                    // Mark task incomplete (if it was previously completed)
                    task.completed.toggle()
                    
                    // Change state of the source of truth on ContentView
                    // This will cause SwiftUI to re-draw the view and it will
                    // reflect fact that this task was completed.
                    withAnimation {
                        triggerListUpdate.toggle()
                    }
                    
                }
            
            Text(task.description)
        }
        .foregroundColor(self.taskColor)
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(task: testData[0], triggerListUpdate: .constant(true))
        TaskCell(task: testData[1], triggerListUpdate: .constant(true))
    }
}
