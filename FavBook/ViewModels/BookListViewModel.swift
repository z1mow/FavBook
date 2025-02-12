//
//  BookListViewModel.swift
//  FavBook
//
//  Created by Şakir Yılmaz ÖĞÜT on 12.02.2025.
//

import Foundation

final class BookListViewModel {
    private let coreDataManager = CoreDataManager.shared
    private let googleBooksService = GoogleBooksService.shared
    
    var books: [Book] = []
    var onBooksUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Data Loading
    
    func loadBooks() {
        books = coreDataManager.fetchBooks(sortDescriptors: [
            NSSortDescriptor(key: "addedDate", ascending: false)
        ])
        onBooksUpdated?()
    }
    
    func searchGoogleBooks(query: String) {
        googleBooksService.searchBooks(query: query) { [weak self] result in
            switch result {
            case .success(let volumes):
                // Convert Google Books results to view model items
                self?.handleGoogleBooksResults(volumes)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    private func handleGoogleBooksResults(_ volumes: [VolumeInfo]) {
        // Here we'll handle the search results from Google Books API
        // This will be implemented when we create the search UI
    }
    
    // MARK: - CRUD Operations
    
    func addBook(from volume: VolumeInfo) {
        let bookInfo = volume.volumeInfo
        let book = coreDataManager.createBook(
            title: bookInfo.title,
            author: bookInfo.mainAuthor,
            bookDescription: bookInfo.description,
            pageCount: Int32(bookInfo.pageCount ?? 0),
            imageURL: bookInfo.imageLinks?.thumbnail,
            isbn: bookInfo.isbn,
            category: bookInfo.categories?.first
        )
        
        if book != nil {
            loadBooks()
        }
    }
    
    func deleteBook(at index: Int) {
        let book = books[index]
        coreDataManager.deleteBook(book)
        loadBooks()
    }
    
    func updateReadingStatus(for book: Book, status: String) {
        book.readingStatus = status
        coreDataManager.updateBook(book)
        loadBooks()
    }
    
    // MARK: - Filtering
    
    func filterBooks(by status: String?) {
        if let status = status {
            books = coreDataManager.fetchBooksByReadingStatus(status)
        } else {
            loadBooks()
        }
        onBooksUpdated?()
    }
    
    func searchLocalBooks(with query: String) {
        if query.isEmpty {
            loadBooks()
        } else {
            books = coreDataManager.searchBooks(with: query)
        }
        onBooksUpdated?()
    }
}
