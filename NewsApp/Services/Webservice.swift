//
//  Webservice.swift
//  NewsApp
//
//  Created by Mohammad Azam on 6/30/21.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidData
    case decodingError
}

class Webservice {
    
    func fetchSourcesAsync(url: URL?) async throws -> [NewsSource] {
        guard let url = url else {
            throw NetworkError.badUrl
        }
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data)
        return newsSourceResponse?.sources ?? []
    }
    
    
//    func fetchSources(url: URL?, completion: @escaping (Result<[NewsSource], NetworkError>) -> Void) {
//
//        guard let url = url else {
//            completion(.failure(.badUrl))
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//
//            guard let data = data, error == nil else {
//                completion(.failure(.invalidData))
//                return
//            }
//
//            let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data)
//            completion(.success(newsSourceResponse?.sources ?? []))
//
//        }.resume()
//
//    }
    
    // using async function to wrap sync function to which we dont have an access (imagine we dont have access to fetchNews)
    func fetchNewsAsync(by sourceId: String, url: URL?) async throws -> [NewsArticle] {
        try await withCheckedThrowingContinuation { continuation in
            fetchNews(by: sourceId, url: url) { result in
                switch result {
                case .success(let newsArticles):
                    continuation.resume(with: .success(newsArticles))
                case .failure(let error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
    
    func fetchNews(by sourceId: String, url: URL?, completion: @escaping (Result<[NewsArticle], NetworkError>) -> Void) {
        
        guard let url = url else {
            completion(.failure(.badUrl))
            return
        }
            
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let newsArticleResponse = try? JSONDecoder().decode(NewsArticleResponse.self, from: data)
            completion(.success(newsArticleResponse?.articles ?? []))
            
        }.resume()
        
    }
    
}
