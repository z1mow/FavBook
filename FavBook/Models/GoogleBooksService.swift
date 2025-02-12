//
//  GoogleBooksService.swift
//  FavBook
//
//  Created by Şakir Yılmaz ÖĞÜT on 12.02.2025.
//

import Foundation
import Alamofire

struct BookResponse: Codable {
    let items: [VolumeInfo]?
}

struct VolumeInfo: Codable {
    let id: String?
    let volumeInfo: BookInfo
    
    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
    }
}

struct BookInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let industryIdentifiers: [IndustryIdentifier]?
    
    var mainAuthor: String {
        return authors?.first ?? "Unknown Author"
    }
    
    var isbn: String? {
        return industryIdentifiers?.first { $0.type == "ISBN_13" }?.identifier
    }
}

struct ImageLinks: Codable {
    let thumbnail: String?
}

struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
}

final class GoogleBooksService {
    static let shared = GoogleBooksService()
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    
    private init() {}
    
    func searchBooks(query: String, completion: @escaping (Result<[VolumeInfo], Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)?q=\(encodedQuery)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: BookResponse.self) { response in
                switch response.result {
                case .success(let bookResponse):
                    completion(.success(bookResponse.items ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
