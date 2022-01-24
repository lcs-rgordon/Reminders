//
//  TaskStore.swift
//  Reminders (iOS)
//
//  Created by Russell Gordon on 2021-01-24.
//

import Foundation

class TaskStore: ObservableObject {

    // MARK: Stored properties
    @Published var tasks: [Task]
    
    // MARK: Initializers
    init(tasks: [Task] = []) {
        
        // Get a URL that points to the saved JSON data containing our list of tasks
        let filename = getDocumentsDirectory().appendingPathComponent(savedTasksLabel)
        print(filename)
        
        // Attempt to load from the JSON in the stored file
        do {
            
            // Load the raw data
            let data = try Data(contentsOf: filename)

            // What was loaded from the file?
            print("Got data from file, contents are:")
            print(String(data: data, encoding: .utf8)!)
            
            // Decode the data into Swift native data structures
            self.tasks = try JSONDecoder().decode([Task].self, from: data)
            
        } catch {

            // What went wrong?
            print(error.localizedDescription)
            print("Could not load data from file, initializing with tasks provided to initializer.")

            // Set up list of tasks to whatever was passed to this initializer
            self.tasks = tasks
        }
        
    }
    
    // MARK: Functions
    func deleteItems(at offsets: IndexSet) {
        // "offsets" contains a set of items selected for deletion
        // The set is then passed to the built-in "remove" method on
        // the "tasks" array which handles removal from the array
        tasks.remove(atOffsets: offsets)
    }
    
    // Invoked to move items around in our list
     func moveItems(from source: IndexSet, to destination: Int) {
         // "source" again contains a set of item(s) being moved
         // "destination" is the location the items are being moved to in the list
         // These arguments are automatically populated for us by the
         // .onMove view modifier provided by the SwiftUI framework
         tasks.move(fromOffsets: source, toOffset: destination)
     }
    
    // Persist the list of tasks
    func persistTasks() {
        
        // Get a URL that points to the saved JSON data containing our list of tasks
        let filename = getDocumentsDirectory().appendingPathComponent(savedTasksLabel)
        
        // Try to encode the data in our people array to JSON
        do {
            
            // Create an encoder
            let encoder = JSONEncoder()
            
            // Ensure the JSON written to the file is human-readable
            encoder.outputFormatting = .prettyPrinted
            
            // Encode the list of prospects we've collected
            let data = try encoder.encode(self.tasks)
            
            // Actually write the JSON file to the documents directory
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            // See the data that was written
            print("Saved data to documents directory successfully.")
            print("===")
            print(String(data: data, encoding: .utf8)!)
            
        } catch {
            
            print(error.localizedDescription)
            print("Unable to write list of tasks to documents directory in app bundle on device.")
            
        }
        
    }

}

var testStore = TaskStore(tasks: testData)
