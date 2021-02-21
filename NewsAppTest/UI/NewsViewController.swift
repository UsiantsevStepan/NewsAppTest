//
//  NewsViewController.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit
import CoreData

class NewsViewController: UIViewController {
    private let newsManager = NewsManager()
    private var totalResults = 0
    private var fetchedResultsController: NSFetchedResultsController<ArticlePreview>!
    private var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private let footerView = FooterView()
    private var isLoading = false
    private var isPageAfterDB = false
    private let newsView = NewsView()
    
    var searchText = ""
    
    var news = [NewsPreviewCellModel]()
    
    override func loadView() {
        super.loadView()
        
        view = newsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsView.tableView.delegate = self
        newsView.tableView.dataSource = self
        newsView.tableView.tableFooterView = footerView
        
        loadPage(with: searchText)
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = ArticlePreview.createFetchRequest()
            let sort = NSSortDescriptor(key: "dateForSorting", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            let predicate = NSPredicate(format: "searchText.value CONTAINS %@", searchText)
            request.predicate = predicate
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: container.viewContext,
                //                sectionNameKeyPath: "searchText.searchText",
                sectionNameKeyPath: "publishDate",
                cacheName: nil
            )
            fetchedResultsController.delegate = self
        }
        
        do {
            try fetchedResultsController.performFetch()
            //            newsView.tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    private func loadPage(with searchText: String) {
        newsManager.loadSerchedNews(searchText: searchText, date: Date()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
                return
            case let .success(data):
                self.totalResults = data
            }
            DispatchQueue.main.async {
                self.loadSavedData()
            }
        }
    }
    
    private func loadNextPage(with searchText: String) {
        if isLoading { return }
        isLoading = true
        footerView.showActivityIndicator()
        
        guard let date = fetchedResultsController.fetchedObjects?.last?.dateForSorting else {
            isLoading = false
            footerView.hideActivityIndicator()
            return
        }
        
        newsManager.loadSerchedNews(searchText: searchText, date: date) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
                return
            case .success:
                DispatchQueue.main.async {
                    self.loadSavedData()
                }
            }
            self.footerView.hideActivityIndicator()
            self.isLoading = false
        }
    }
}

extension NewsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            newsView.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .update:
            newsView.tableView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            newsView.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        default:
            print("Unknown case of didChange sectionInfo")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let indexPath = indexPath else { return }
            newsView.tableView.reloadRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            newsView.tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            newsView.tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            newsView.tableView.deleteRows(at: [indexPath], with: .fade)
            newsView.tableView.insertRows(at: [newIndexPath], with: .fade)
        @unknown default:
            print("Add new case to didChange anObject")
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsView.tableView.endUpdates()
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        guard let numberOfRows = sectionInfo?.numberOfObjects else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseId, for: indexPath) as! NewsTableViewCell
        let article = fetchedResultsController.object(at: indexPath)
        cell.configure(article: article)
        
        return cell
    }
    
    
}

extension NewsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let fetchedResults = fetchedResultsController else { return 0 }
        guard let sections = fetchedResults.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > 0, offsetY > contentHeight - scrollView.frame.height - 100 {
            loadNextPage(with: searchText)
        }
    }
}

