//
//  FooterView.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 20.02.2021.
//

import UIKit

class FooterView: UIView {
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
            pageActivityIndicator.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 4),
            pageActivityIndicator.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            pageActivityIndicator.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -4)
        ])
        
        pageActivityIndicator.style = .medium
    }
    
    func showActivityIndicator() {
        pageActivityIndicator.isHidden = false
        pageActivityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        pageActivityIndicator.stopAnimating()
        pageActivityIndicator.isHidden = true
    }
}

