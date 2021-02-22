//
//  NewsView.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 20.02.2021.
//

import UIKit

final class NewsView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseId)
        
        addSubviews()
        setConstraints()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureSubviews() {
        tableView.rowHeight = 122
        tableView.estimatedRowHeight = 122
    }
}

