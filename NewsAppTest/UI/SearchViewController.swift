//
//  SearchViewController.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
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
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news..."
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("Clicked")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
//        navigationItem.searchController?.isActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        present(SearchResultsViewController(), animated: true, completion: nil)
        self.navigationController?.pushViewController(SearchResultsViewController(), animated: true)
        print("Search")
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
}
