//
//  SearchResultsViewController.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit

class SearchResultsViewController: UIViewController {
    private let tableView = UITableView()
    
    let news: [(String, String)] = [("News", "qereqreqteqqeteqtqe eqreq qereq qereiq peoqir poqeipri pqeir peqir popeqi rpqeior poqei prq"), ("Neqro eqo", "QEReqre qer qer eqrqer qer qerqe"), ("Qer ovovov", "eqrqe qer eqr eqr eqreqreqr"), ("eqreqrer eqreqreqre qreq", "eqrqereqreqrqereqreqr eqrreq reqr eqr")]
    let newsImages: [UIImage] = [#imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "placeholder"), #imageLiteral(resourceName: "placeholder")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseId)
        
        addSubviews()
        setConstraints()
        configureSubviews()
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

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseId, for: indexPath) as! NewsTableViewCell
        
        cell.configure(title: news[indexPath.row].0, description: news[indexPath.row].1, image: newsImages[indexPath.row])
        
        return cell
    }
    
    
}

extension SearchResultsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}

