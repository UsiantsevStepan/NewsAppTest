//
//  FooterView.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 20.02.2021.
//

import UIKit

final class FooterView: UIView {
    private var pageActivityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setSubview() {
        addSubview(pageActivityIndicator)
        
        pageActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageActivityIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            pageActivityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            pageActivityIndicator.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
        
        pageActivityIndicator.style = .medium
        pageActivityIndicator.hidesWhenStopped = true
    }
    
    func showActivityIndicator() {
        pageActivityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        pageActivityIndicator.stopAnimating()
    }
}

