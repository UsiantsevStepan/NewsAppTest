//
//  NewsView.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 20.02.2021.
//

import UIKit

class NewsView: UIView {
    static let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NewsView.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseId)
        
        addSubviews()
        setConstraints()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
        private func addSubviews() {
            addSubview(NewsView.tableView)
        }
    
        private func setConstraints() {
            NewsView.tableView.translatesAutoresizingMaskIntoConstraints = false
    
            NSLayoutConstraint.activate([
                NewsView.tableView.topAnchor.constraint(equalTo: topAnchor),
                NewsView.tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                NewsView.tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                NewsView.tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    
        private func configureSubviews() {
            NewsView.tableView.rowHeight = 120
            NewsView.tableView.estimatedRowHeight = 120
        }
}

