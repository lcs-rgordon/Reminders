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
            
            TabView {
                
                // We only need the NavigationView on iOS...
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
            #if os(macOS)
            // Needed on macOS to set the size of the initial window
            .frame(minWidth: 475, idealWidth: 525, maxWidth: 575, minHeight: 200, idealHeight: 300)
            // Add a bit of padding for the window on macOS
            .padding(.top)
            #endif

        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                
                print("Inactive")
                
            } else if newPhase == .active {
                
                print("Active")
                
            } else if newPhase == .background {
                
                print("Background")
                
                // Save the list of tasks
                store.save()
                
            }
        }
        #if os(macOS)
        // Builds menus
        .commands {
            CommandGroup(replacing: .appTermination) {
                // Add Quit Reminders command
                Button(action: {
                    // Save tasks
                    store.save()
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
