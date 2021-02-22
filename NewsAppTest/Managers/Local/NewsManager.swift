//
//  NewsManager.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit
import CoreData

final class NewsManager {
    enum NewsManagerError: LocalizedError {
        case parseError
        case noNews
        
        var errorDescription: String? {
            switch self {
            case .parseError:
                return "Data hasn't been parsed or has been parsed incorrectly."
            case .noNews:
                return "No news found. Try another search text!"
            }
        }
    }
    
    private let networkManager = NetworkManager()
    private let dataParser = DataParser()
    private var searchTotalResults = 0
    private var searchData = [(String, [Article])]()
    
    //MARK: - Reference to child MOC
    let context = CoreDataStack.instance.childMoc
    
    public func loadSerchedNews(searchText: String, date: Date, completion: @escaping ((Result<Int, Error>)) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        
        group.enter()
        queue.async {
            self.networkManager.getData(with: ApiEndpoint.searchNewsUpTo(text: searchText, date: date.iso8601withFractionalSeconds)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case let .failure(error):
                    completion(.failure(error))
                    group.leave()
                case let .success(data):
                    guard let searchData = self.dataParser.parse(withData: data, to: NewsData.self) else {
                        completion(.failure(NewsManagerError.parseError))
                        group.leave()
                        return
                    }
                    
                    if searchData.totalResults == 0 {
                        completion(.failure(NewsManagerError.noNews))
                        group.leave()
                        return
                    }
                    
                    self.searchData.append((searchText, searchData.articles))
                    self.searchTotalResults = searchData.totalResults
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            // MARK: - Saving news Data to DB
            for article in self.searchData {
                self.saveNews(text: article.0, news: article.1)
            }
            
            completion(.success(self.searchTotalResults))
        }
    }
    
    public func saveSearchText(text: String) {
        // MARK: - Fetch SearchText entity which stores news
        let request = SearchText.createFetchRequest() as NSFetchRequest<SearchText>
        let predicate = NSPredicate(format: "value == %@", text)
        request.predicate = predicate
        
        if let searchText = try? context.fetch(request).first {
            searchText.dateForSorting = Date()
        } else {
            // MARK: - Creating SearchText entity which will store news
            let searchText = SearchText(context: context)
            searchText.value = text
            searchText.dateForSorting = Date()
        }
        
        
        // MARK: - Saving data to DB
        context.saveContext() {
            CoreDataStack.instance.context.saveContext()
        }
    }
    
    public func saveIsViewed(article: ArticlePreview) {
        article.isViewed = true
        
        context.saveContext() {
            CoreDataStack.instance.context.saveContext()
        }
    }
    
    private func saveNews(text: String, news: [Article]) {
        // MARK: - Fetch SearchText entity which stores news
        let request = SearchText.createFetchRequest() as NSFetchRequest<SearchText>
        let predicate = NSPredicate(format: "value == %@", text)
        request.predicate = predicate
        
        guard let searchText = try? context.fetch(request).first else { return }
        
        // MARK: - Creating an article object
        for article in news {
            let newArticle = ArticlePreview(context: context)
            
            // MARK: - Fetch existing news
            let request = ArticlePreview.createFetchRequest() as NSFetchRequest<ArticlePreview>
            let predicate = NSPredicate(format: "id == %@", (article.title ?? "") + (article.description ?? ""))
            request.predicate = predicate
            
            if (try? context.fetch(request).first) != nil {
                continue
            } else {
                
                newArticle.title = article.title
                newArticle.articleDesription = article.description
                newArticle.id = (article.title ?? "") + (article.description ?? "")
                newArticle.articlePath = article.url
                newArticle.imagePath = article.urlToImage
                newArticle.publishDate = dateFormat(with: article.publishedAt)
                newArticle.dateForSorting = article.publishedAt
                newArticle.isViewed = false
                newArticle.searchKeyword = searchText.value
            }
        }
        
        // MARK: - Saving data to DB
        context.saveContext() {
            CoreDataStack.instance.context.saveContext()
        }
    }
}

private extension NewsManager {
    func dateFormat(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: date)
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String {
        return Formatter.iso8601withFractionalSeconds.string(from: self)
    }
}
