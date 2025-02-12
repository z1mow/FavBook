//
//  CoreDataManager.swift
//  FavBook
//
//  Created by Şakir Yılmaz ÖĞÜT on 12.02.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavBook")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    // Create
    func createBook(title: String, author: String, bookDescription: String?, pageCount: Int32?,
                   imageURL: String?, isbn: String?, category: String?, readingStatus: String = "ToRead") -> Book? {
        let book = Book(context: context)
        book.title = title
        book.author = author
        book.bookDescription = bookDescription
        book.pageCount = pageCount ?? 0
        book.imageURL = imageURL
        book.isbn = isbn
        book.category = category
        book.readingStatus = readingStatus
        book.addedDate = Date()
        
        saveContext()
        return book
    }
    
    // Read
    func fetchBooks(with predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Book] {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching books: \(error)")
            return []
        }
    }
    
    // Update
    func updateBook(_ book: Book) {
        saveContext()
    }
    
    // Delete
    func deleteBook(_ book: Book) {
        context.delete(book)
        saveContext()
    }
    
    // MARK: - Helper Methods
    
    func fetchBooksByReadingStatus(_ status: String) -> [Book] {
        let predicate = NSPredicate(format: "readingStatus == %@", status)
        return fetchBooks(with: predicate)
    }
    
    func searchBooks(with searchText: String) -> [Book] {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR author CONTAINS[cd] %@",
                                  searchText, searchText)
        return fetchBooks(with: predicate)
    }
}
