//
//  NewsManager.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit
import CoreData

class NewsManager {
    enum NewsManagerError: LocalizedError {
        case parseError
        
        var errorDescription: String? {
            return "Data hasn't been parsed or has been parsed incorrectly"
        }
    }
    
    private let networkManager = NetworkManager()
    private let dataParser = DataParser()
//    private var searchData = [Article]()
    private var searchTotalResults = 0
    private var searchData = [(String, [Article])]()
    
    //MARK: - Reference to manged object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let persistentStoreCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
    
//    func getNews(searchText: String) -> (String, [NewsPreviewCellModel]) {
//        let fetchedNews = fetchNews(searchText: searchText)
//        return (searchText, setSearchedNewsPreviewCellModel(from: fetchedNews))
//    }
    
    public func loadSearchedMovies(searchText: String, page: Int, completion: @escaping ((Result<(Int), Error>)) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .background)
        
        group.enter()
        queue.async {
            self.networkManager.getData(with: ApiEndpoint.searchNews(text: searchText, page: page)) { [weak self] result in
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
    
    private func saveNews(text: String, news: [Article]) -> Void {
        
        // MARK: - Creating SearchText entity which will store news
        let searchText = SearchText(context: context)
        searchText.value = text
        searchText.dateForSorting = Date()
        
        // MARK: - Creating an article object
        for article in news {
            let newArticle = ArticlePreview(context: context)
            
            newArticle.title = article.title
            newArticle.articleDesription = article.description
            newArticle.articlePath = article.url
            newArticle.imagePath = article.urlToImage
            newArticle.publishDate = dateFormat(with: article.publishedAt)
            newArticle.dateForSorting = article.publishedAt
            newArticle.isViewed = false
            
            searchText.addToNews(newArticle)
        }
        
        // MARK: - Saving data to DB
        do {
            try context.save()
        } catch let error as NSError {
            print(error, error.localizedDescription)
        }
    }
    
//    func fetchNews(searchText: String) -> [ArticlePreview] {
//        do {
//            let request = SearchText.createFetchRequest() as NSFetchRequest<SearchText>
//
//            let predicate = NSPredicate(format: "searchText CONTAINS %@", searchText)
//            request.predicate = predicate
//
//            let newsList = try context.fetch(request)
//            let newsSet = newsList.first?.news?.allObjects as? [ArticlePreview] ?? []
////            let sortedNews = newsSet.sorted { $0.publishDate > $1.publishDate }
//            return newsSet
//        } catch {
//            return []
//        }
//    }
    
//    func fetchPreviousSearchRequests() -> [SearchText] {
//        do {
//            let request = SearchText.createFetchRequest() as NSFetchRequest<SearchText>
//            let searchRequests = try context.fetch(request)
//            let sortedSearchRequests = searchRequests.sorted { $0.date > $1.date }
//
//            return sortedSearchRequests
//        } catch {
//            return []
//        }
//    }
    
//    private func setSearchedNewsPreviewCellModel(from newsData: [ArticlePreview]) -> [NewsPreviewCellModel] {
//        return newsData.map { article -> NewsPreviewCellModel in
//            return NewsPreviewCellModel(
//                title: article.title,
//                description: article.articleDesription,
//                imagePath: article.imagePath ?? ""
//            )
//        }
//    }
}

private extension NewsManager {
    func dateFormat(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}
