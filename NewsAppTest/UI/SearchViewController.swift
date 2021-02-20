//
//  SearchViewController.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let newsManager = NewsManager()
//    private var searchRequests = [SearchText]()
    private var fetchedResultsController: NSFetchedResultsController<SearchText>!
    private var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        loadSavedData()
        
        addSubviews()
        setConstraints()
        configureSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.next?.touchesBegan(touches, with: event)

        searchController.searchBar.endEditing(true)
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController?.isActive = false
        print("touch")
    }
    
    private func loadSavedData() {
        if fetchedResultsController == nil {
            let request = SearchText.createFetchRequest()
            let sort = NSSortDescriptor(key: "dateForSorting", ascending: false)
            request.sortDescriptors = [sort]
//            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: container.viewContext,
                //                sectionNameKeyPath: "searchText.searchText",
                sectionNameKeyPath: nil,
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
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func configureSubviews() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        
        searchController.searchBar.delegate = self
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.setValue("Search", forKey: "cancelButtonText")
        searchController.automaticallyShowsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news..."
    }
}

extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        @unknown default:
            print("Add new case to didChange anObject")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        let searchResultsViewController = SearchResultsViewController()
        searchResultsViewController.searchText = searchText
        self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        print("Clicked")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchController.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard
            let searchText = searchBar.text,
            !searchText.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            searchBar.setShowsCancelButton(false, animated: false)
            return
        }
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
//        navigationItem.searchController?.isActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText != "" else { return }
        let searchResultsViewController = SearchResultsViewController()
        searchResultsViewController.searchText = searchText
        self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        print("Search")
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        searchRequests.count
        let sectionInfo = fetchedResultsController.sections?[section]
        guard let numberOfRows = sectionInfo?.numberOfObjects else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        let searchRequest = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = searchRequest.value
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}