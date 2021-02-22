//
//  SearchViewController.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit
import CoreData

final class SearchViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let newsManager = NewsManager()
    private var fetchedResultsManager: FetchedResultsManager<SearchText>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        fetchedResultsManager = FetchedResultsManager(
            delegate: self,
            sortDescriptors: [NSSortDescriptor(key: "dateForSorting", ascending: false)]
        )
        
        addSubviews()
        setConstraints()
        configureSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
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
        
        searchController.searchBar.delegate = self
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.setValue("Search", forKey: "cancelButtonText")
        searchController.automaticallyShowsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news..."
    }
    
    private func routeToNewsViewController(searchText: String, viewController: NewsViewController) {
        newsManager.saveSearchText(text: searchText)
        viewController.searchText = searchText
        self.navigationController?.pushViewController(viewController, animated: true)
        navigationItem.searchController?.isActive = false
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
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        let searchResultsViewController = NewsViewController()
        newsManager.saveSearchText(text: searchText)
        searchResultsViewController.searchText = searchText
        self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        navigationItem.searchController?.isActive = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchBar.setShowsCancelButton(false, animated: true)
            return
        }
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText != "" else { return }
        let searchResultsViewController = NewsViewController()
        newsManager.saveSearchText(text: searchText)
        searchResultsViewController.searchText = searchText
        self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        navigationItem.searchController?.isActive = false
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsManager?.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        guard let searchRequest = fetchedResultsManager?.fetchedResultsController.object(at: indexPath) else { return cell }
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = searchRequest.value
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
        navigationItem.searchController?.isActive = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchText = fetchedResultsManager?.fetchedResultsController.object(at: indexPath).value else { return }
        let searchResultsViewController = NewsViewController()
        newsManager.saveSearchText(text: searchText)
        searchResultsViewController.searchText = searchText
        self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        navigationItem.searchController?.isActive = false
    }
}
