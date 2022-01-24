//
//  DeleteMenuItem.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2022-01-24.
//

import Foundation
import SwiftUI

// Adds a context menu to a view
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

// Makes a custom view modifier named deleteMenuItem
extension View {
    func deleteMenuItem(store: TaskStore, task: Task) -> some View {
        modifier(DeleteMenuItem(store: store, task: task))
    }
}
