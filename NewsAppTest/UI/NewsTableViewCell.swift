//
//  NewsTableViewCell.swift
//  NewsAppTest
//
//  Created by Степан Усьянцев on 18.02.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let reuseId = "NewsTableViewCellReuseId"
    
//    private let newsImage = UIImageView()
    private let newsImage = NewsImage(frame: .zero)
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
        newsImage.image = nil
        titleLabel.alpha = 1
        descriptionLabel.alpha = 1
        newsImage.alpha = 1
        newsImage.cancelTask()
    }
    
    private func addSubviews() {
//        contentView.addSubview(newsImage)
//        [titleLabel, descriptionLabel].forEach(newsImage.addSubview)
        [newsImage, titleLabel, descriptionLabel].forEach(contentView.addSubview)
    }
    
    private func setConstraints() {
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let marginGuide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            newsImage.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            newsImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            newsImage.heightAnchor.constraint(equalToConstant: 100),
            newsImage.widthAnchor.constraint(equalToConstant: 100),
            newsImage.bottomAnchor.constraint(lessThanOrEqualTo: marginGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: newsImage.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: newsImage.trailingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
            ])
    }
    
    private func configureSubviews() {
        newsImage.clipsToBounds = true
        newsImage.contentMode = .scaleAspectFill
        newsImage.layer.cornerRadius = 8
        newsImage.layer.borderWidth = 0.5
        newsImage.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = .byTruncatingTail
    }
    
    func configure(article: ArticlePreview) {
        titleLabel.text = article.title
        descriptionLabel.text = article.articleDesription
//        guard let urlString = article.imagePath else { return }
        
//        print(urlString)
        newsImage.setImage(from: article.imagePath)
        
        if article.isViewed {
            titleLabel.alpha = 0.5
            descriptionLabel.alpha = 0.5
            newsImage.alpha = 0.5
        }
    }
}

extension String {
    func getLabelFrameHeight(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}
