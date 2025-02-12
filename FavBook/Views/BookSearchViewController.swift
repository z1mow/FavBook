//
//  BookSearchViewController.swift
//  FavBook
//
//  Created by Şakir Yılmaz ÖĞÜT on 12.02.2025.
//

import UIKit

protocol BookSearchViewControllerDelegate: AnyObject {
    func didSelectBook(_ book: VolumeInfo)
}

class BookSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: BookListViewModel!
    private var searchResults: [VolumeInfo] = []
    weak var delegate: BookSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchBar()
        setupViewModel()
    }
    
    private func setupUI() {
        title = "Search Books"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search by title, author, or ISBN"
        searchBar.becomeFirstResponder()
    }
    
    private func setupViewModel() {
        viewModel.onBooksUpdated = { [weak self] in
            guard let self = self else { return }
            self.searchResults = self.viewModel.searchResults
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            print("Search error: \(error)")
            // TODO: Show error alert
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension BookSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let book = searchResults[indexPath.row].volumeInfo
        
        // Configure cell
        cell.textLabel?.text = book.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.numberOfLines = 2
        
        // Create detail text with author and category
        var detailText = book.mainAuthor
        if let category = book.categories?.first {
            detailText += " • \(category)"
        }
        cell.detailTextLabel?.text = detailText
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.textColor = .systemGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBook = searchResults[indexPath.row]
        
        // Create alert controller
        let alert = UIAlertController(
            title: "Add Book",
            message: "Do you want to add '\(selectedBook.volumeInfo.title)' to your library?",
            preferredStyle: .alert
        )
        
        // Add actions
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // Add the book
            self.delegate?.didSelectBook(selectedBook)
            
            // Wait for Core Data to update and dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.dismiss(animated: true)
            }
        })
        
        // Present alert
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchResults = []
            tableView.reloadData()
            return
        }
        
        viewModel.searchGoogleBooks(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
