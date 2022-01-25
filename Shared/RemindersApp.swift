//
//  RemindersApp.swift
//  Shared
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

@main
struct RemindersApp: App {
    
    // Detect when app moves between the foreground, background, and inactive states
    @Environment(\.scenePhase) var scenePhase
    
    // Create the source of truth for our list of tasks (create the view model)
    @StateObject private var store = TaskStore(tasks: testData)
    
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            NavigationView {
                ContentView(store: store)
            }
            #else
                ContentView(store: store)
                // Set the ideal size of the window on macOS
                .frame(minWidth: 475, idealWidth: 525, maxWidth: 575, minHeight: 200, idealHeight: 300)
            #endif
        }
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .inactive {
                
                print("Inactive")
                
            } else if newPhase == .active {
                
                print("Active")
                
            } else if newPhase == .background {
                
                print("Background")
                
                // Permanently save the list of tasks
                store.persistTasks()
                
            }
            
        }
        #if os(macOS)
        .commands {
            
            CommandGroup(replacing: .appTermination) {
                
                // Add Quit Reminders command
                Button(action: {
                    
                    // Permanently save the list of tasks
                    store.persistTasks()
                    
                    // Close application
                    exit(0)
                    
                }, label: {
                    Text("Quit Reminders")
                })
                    .keyboardShortcut("Q", modifiers: [.command])
                
            }
            
        }
        #endif
        
    }
}
