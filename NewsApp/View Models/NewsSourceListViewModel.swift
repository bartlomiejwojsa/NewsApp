//
//  NewsSourceListViewModel.swift
//  NewsApp
//
//  Created by Mohammad Azam on 6/30/21.
//

import Foundation

@MainActor
class NewsSourceListViewModel: ObservableObject {
    
    @Published var newsSources: [NewsSourceViewModel] = []
    
    lazy var apiKey: String = Constants.getApiKey()

    func getSources() async {
        do {
            let result = try await Webservice().fetchSourcesAsync(url: self.getSourcesUrl())
//            DispatchQueue.main.async {
                self.newsSources = result.map(NewsSourceViewModel.init)
//            }
        } catch {
            print(error)
        }
//        Webservice().fetchSources(url: Constants.Urls.sources) { result in
//            switch result {
//                case .success(let newsSources):
//                    DispatchQueue.main.async {
//                        self.newsSources = newsSources.map(NewsSourceViewModel.init)
//                    }
//                case .failure(let error):
//                    print(error)
//            }
//        }
        
    }
    private func getSourcesUrl() -> URL? {
        return URL(string: "https://newsapi.org/v2/sources?apiKey=\(self.apiKey)")
    }
    
}

struct NewsSourceViewModel {
    
    fileprivate var newsSource: NewsSource
    
    var id: String {
        newsSource.id
    }
    
    var name: String {
        newsSource.name
    }
    
    var description: String {
        newsSource.description
    }
    
    static var `default`: NewsSourceViewModel {
        let newsSource = NewsSource(id: "abc-news", name: "ABC News", description: "This is ABC news")
        return NewsSourceViewModel(newsSource: newsSource)
    }
}
