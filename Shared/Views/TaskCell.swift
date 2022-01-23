//
//  TaskCell.swift
//  Reminders
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

struct TaskCell: View {
    
    @ObservedObject var task: Task
    
    // Whether tasks are shown or hidden
    @Binding var completedTaskVisibility: Bool
    
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
                    
                    // When the task has been changed to completed, modify task visibility to make the completed task disappear
                    withAnimation {
                        completedTaskVisibility.toggle()
                        completedTaskVisibility.toggle()
                    }
                    
                }
            
            Text(task.description)
        }
        .foregroundColor(self.taskColor)
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(task: testData[0], completedTaskVisibility: .constant(true))
        TaskCell(task: testData[1], completedTaskVisibility: .constant(true))
    }
}
