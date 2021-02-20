//
//  SearchResultsViewController.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit
import CoreData

class SearchResultsViewController: UIViewController {
    private let newsManager = NewsManager()
    private var totalResults = 0
    private var fetchedResultsController: NSFetchedResultsController<ArticlePreview>!
    private var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private let footerView = FooterView()
    private var isLoading = false
    private var isPageAfterDB = false
    
    let tableView = UITableView()
    var searchText = ""
    
    var news = [NewsPreviewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseId)
        
        addSubviews()
        setConstraints()
        configureSubviews()
        
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
            tableView.reloadData()
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
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureSubviews() {
        tableView.tableFooterView = footerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
}

extension SearchResultsViewController: NSFetchedResultsControllerDelegate {
    
}

extension SearchResultsViewController: UITableViewDataSource {
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

extension SearchResultsViewController: UITableViewDelegate {
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
        
        if offsetY > 0, offsetY > contentHeight - scrollView.frame.height - 200 {
            loadNextPage(with: searchText)
        }
    }
}

