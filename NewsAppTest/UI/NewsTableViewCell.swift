//
//  NewsTableViewCell.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let reuseId = "NewsTableViewCellReuseId"
    
    private let newsImage = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    private func addSubviews() {
//        contentView.addSubview(newsImage)
//        [titleLabel, descriptionLabel].forEach(newsImage.addSubview)
        [titleLabel, descriptionLabel].forEach(contentView.addSubview)
    }
    
    private func setConstraints() {
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let marginGuide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
//            newsImage.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8),
//            newsImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 8),
//            newsImage.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -8),
//            newsImage.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -4),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -4),
            descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -4)
            ])
    }
    
    private func configureSubviews() {
        newsImage.layer.cornerRadius = 8
        newsImage.contentMode = .scaleAspectFit
        newsImage.image = #imageLiteral(resourceName: "placeholder")
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        titleLabel.textColor = .white
        titleLabel.text = "News"
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
//        descriptionLabel.textColor = .white
        descriptionLabel.text = "EOQRPEPQR oepqpropqe oeqrp eqorp eqor qper opqe"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
//        tableView.separatorStyle = .none
    }
    
    func configure(article: ArticlePreview) {
        titleLabel.text = article.title
        descriptionLabel.text = article.articleDesription
//        newsImage.image = image
    }
}
