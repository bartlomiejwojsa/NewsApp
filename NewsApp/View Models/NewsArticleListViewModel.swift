//
//  NewsArticleListViewModel.swift
//  NewsApp
//
//  Created by Mohammad Azam on 6/30/21.
//

import Foundation

// MainActor is a property wrapper which makes:
// every property & function of this class will be called on the main thread
// Point of USAGE: we use this as an equivalent to calling DispatchQueue.main.async in many different places
@MainActor
class NewsArticleListViewModel: ObservableObject {
    
    @Published var newsArticles = [NewsArticleViewModel]()
    
    lazy var apiKey: String = Constants.getApiKey()
    
    func getNewsBy(sourceId: String) async {
        do {
            let articles = try await Webservice().fetchNewsAsync(by: sourceId, url: self.getArticlesUrl(by: sourceId))
//            DispatchQueue.main.async {
                self.newsArticles = articles.map(NewsArticleViewModel.init)
//            }
        } catch {
            print(error)
        }
//
//        Webservice().fetchNews(by: sourceId, url: Constants.Urls.topHeadlines(by: sourceId)) { result in
//            switch result {
//                case .success(let newsArticles):
//                    DispatchQueue.main.async {
//                        self.newsArticles = newsArticles.map(NewsArticleViewModel.init)
//                    }
//                case .failure(let error):
//                    print(error)
//            }
//        }
    }
    
    private func getArticlesUrl(by sourceId: String) -> URL? {
        return URL(string: "https://newsapi.org/v2/top-headlines?sources=\(sourceId)&apiKey=\(self.apiKey)")
    }
    
}

struct NewsArticleViewModel {
    
    let id = UUID()
    fileprivate let newsArticle: NewsArticle
    
    var title: String {
        newsArticle.title
    }
    
    var description: String {
        newsArticle.description ?? ""
    }
    
    var author: String {
        newsArticle.author ?? ""
    }
    
    var urlToImage: URL? {
        URL(string: newsArticle.urlToImage ?? "")
    }
    
}
