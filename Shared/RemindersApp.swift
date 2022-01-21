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
    
    // Create the source of truth for tasks in this app
    @StateObject private var store = TaskStore(tasks: testData)
    
    var body: some Scene {
        WindowGroup {
            
            TabView {

                #if os(iOS)
                NavigationView {
                    ContentView(store: store)
                }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("List")
                }
                #else
                ContentView(store: store)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                #endif
                
                #if os(iOS)
                NavigationView {
                    ImportantTasksView(store: store)
                }
                .tabItem {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("Important")
                }
                #else
                ImportantTasksView(store: store)
                    .tabItem {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text("Important")
                    }
                #endif
                
            }
            // Needed on macOS to set the size of the initial window
            .frame(minWidth: 350, idealWidth: 400, maxWidth: 500)
            
        }
        // When the app is quit or backgrounded, this closure will run
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                
                print("Inactive")
                
            } else if newPhase == .active {
                
                print("Active")
                
            } else if newPhase == .background {
                
                print("Background")
                
                // Save the list of tasks
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(store.tasks) {
                    print("Saving tasks list now, app has been backgrounded or quit...")
                    // Actually save the tasks to UserDefaults
                    UserDefaults.standard.setValue(encoded, forKey: "tasks")
                }
                
                
            }
        }
    }
    
}
