//
//  JournalViewModal.swift
//  Journal
//
//  Created by Goutham Das T on 29/10/24.
//

import Foundation
import CoreData
import Combine

protocol JournalViewModelProtocol {
    var entriesPublisher: Published<[Entry]>.Publisher { get }
    var entries: [Entry] { get }
    func fetchEntries()
    func addEntry(with title: String, body content: String)
    func deleteEntry(at index: Int)
}

class JournalViewModel: ObservableObject, JournalViewModelProtocol {
    @Published private(set) var entries: [Entry] = []
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        fetchEntries()
    }
    
    var entriesPublisher: Published<[Entry]>.Publisher {
        $entries
    }
    
    // Fetch entries from core data
    func fetchEntries() {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            entries = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch entries: \(error)")
        }
    }
    
    // Add entry
    func addEntry(with title: String, body content: String) {
        let newEntry = Entry(context: context)
        newEntry.title = title
        newEntry.content = content
        newEntry.date = Date() // Set the current date for the new entry
        
        do {
            try context.save()
            entries.insert(newEntry, at: 0) // Insert at the beginning
        } catch {
            print("Failed to save new entry: \(error)")
        }
    }
    
    // Delete entry
    func deleteEntry(at index: Int) {
        let entry = entries[index]
        context.delete(entry)
        
        do {
            try context.save()
            // Remove after saving the context
            entries.remove(at: index)
        } catch {
            print("Failed to delete entry: \(error)")
        }
    }
    
}
