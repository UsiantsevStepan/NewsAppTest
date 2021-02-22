//
//  NewsViewController.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit
import CoreData
import SafariServices

class NewsViewController: UIViewController {
    private let newsManager = NewsManager()
    private var totalResults = 0
    private var fetchedResultsManager: FetchedResultsManager<ArticlePreview>?
    private let footerView = FooterView()
    private var isLoading = false
    private var isPageAfterDB = false
    private let newsView = NewsView()
    
    var searchText = ""
    
    override func loadView() {
        view = newsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = searchText
        
        newsView.tableView.delegate = self
        newsView.tableView.dataSource = self
        newsView.tableView.tableFooterView = footerView
        fetchedResultsManager = FetchedResultsManager(
            delegate: self,
            predicate: NSPredicate(format: "searchText.value CONTAINS %@", searchText),
            sortDescriptors: [NSSortDescriptor(key: "dateForSorting", ascending: false)],
            sectionNameKeyPath: "publishDate"
        )
        
        loadPage(with: Date())
    }
    
    private func loadPage(with date: Date) {
        isLoading = true
        footerView.showActivityIndicator()
        
        print("StartDate: \(date)")
        newsManager.loadSerchedNews(searchText: searchText, date: date) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
                return
            case let .success(data):
                self.totalResults = data
            }
            self.footerView.hideActivityIndicator()
            self.isLoading = false
            print("Date: \(String(describing: self.fetchedResultsManager?.fetchedResultsController.fetchedObjects?.last?.dateForSorting))")
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
            newsView.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .none)
        case .update:
            newsView.tableView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .none)
        case .delete:
            newsView.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .none)
        default:
            print("Unknown case of didChange sectionInfo")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            guard let indexPath = indexPath else { return }
            newsView.tableView.reloadRows(at: [indexPath], with: .none)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            newsView.tableView.insertRows(at: [newIndexPath], with: .none)
        case .delete:
            guard let indexPath = indexPath else { return }
            newsView.tableView.deleteRows(at: [indexPath], with: .none)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            newsView.tableView.deleteRows(at: [indexPath], with: .none)
            newsView.tableView.insertRows(at: [newIndexPath], with: .none)
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
        fetchedResultsManager?.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseId, for: indexPath) as! NewsTableViewCell
        guard let article = fetchedResultsManager?.fetchedResultsController.object(at: indexPath) else { return cell }
        cell.configure(article: article)
        
        return cell
    }
    
    
}

extension NewsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsManager?.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsManager?.fetchedResultsController.sections?[section].name
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > 0, offsetY > contentHeight - scrollView.frame.height {
            if isLoading { return }
            guard let date = fetchedResultsManager?.fetchedResultsController.fetchedObjects?.last?.dateForSorting else { return }
            loadPage(with: date)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsView.tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let urlString = fetchedResultsManager?.fetchedResultsController.object(at: indexPath).articlePath,
            let url = URL(string: urlString)
        else { return }
        
        guard let article = fetchedResultsManager?.fetchedResultsController.object(at: indexPath) else { return }
        newsManager.saveIsViewed(article: article)
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        200
//    }
}

