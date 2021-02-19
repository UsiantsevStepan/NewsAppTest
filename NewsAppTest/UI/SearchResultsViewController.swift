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
    private var currentPage = 1
    private var fetchedResultsController: NSFetchedResultsController<ArticlePreview>!
    private var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    let tableView = UITableView()
    var searchText = ""
    
    //    let news: [(String, String)] = [("News", "qereqreqteqqeteqtqe eqreq qereq qereiq peoqir poqeipri pqeir peqir popeqi rpqeior poqei prq"), ("Neqro eqo", "QEReqre qer qer eqrqer qer qerqe"), ("Qer ovovov", "eqrqe qer eqr eqr eqreqreqr"), ("eqreqrer eqreqreqre qreq", "eqrqereqreqrqereqreqr eqrreq reqr eqr")]
    var news = [NewsPreviewCellModel]()
    let newsImages: [UIImage] = [#imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "placeholder")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseId)
        
        addSubviews()
        setConstraints()
        configureSubviews()
        
        loadPage(with: searchText, pageNumber: currentPage)
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
        
        //        fetchedResultsController.fetchRequest.predicate =
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    private func loadPage(with searchText: String, pageNumber: Int) {
        newsManager.loadSearchedMovies(searchText: searchText, page: pageNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
                return
            case let .success(totalResults):
                self.totalResults = totalResults
                //                self.news += news
                self.currentPage += 1
            }
            DispatchQueue.main.async {
                self.loadSavedData()
            }
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        //        tableView.estimatedRowHeight = 64
        //        tableView.separatorStyle = .none
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
}

