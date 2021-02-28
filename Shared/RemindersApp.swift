//
//  RemindersApp.swift
//  Shared
//
//  Created by Russell Gordon on 2021-01-24.
//

import SwiftUI

@main
struct RemindersApp: App {
    
    @StateObject private var store = TaskStore(tasks: testData)
    
    var body: some Scene {
        WindowGroup {
            
            TabView {
                
                NavigationView {
                    ContentView(store: store)
                }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("List")
                }
                
                NavigationView {
                    ImportantTasksView(store: store)
                }
                .tabItem {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("Important")
                }
                
                
            }
        }
    }
}
