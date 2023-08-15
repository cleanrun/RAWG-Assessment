//
//  DetailView.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import UIKit

final class DetailView: BaseView {
    private lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var ratingAndPlayedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()

    override func setupSubviews() {
        super.setupSubviews()
        
        addSubviews(bannerImageView, infoStackView, descriptionLabel, loadingIndicator)
        infoStackView.addArrangedSubviews(titleLabel, releaseDateLabel, ratingAndPlayedLabel)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leftAnchor.constraint(equalTo: leftAnchor),
            bannerImageView.rightAnchor.constraint(equalTo: rightAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 200),
            
            infoStackView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 16),
            infoStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            infoStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupData(_ game: Game) {
        if let imageURL = URL(string: game.backgroundImage ?? "") {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageFromURL = UIImage.downloadImageFromURL(imageURL)
                DispatchQueue.main.async { [unowned self] in
                    self.bannerImageView.image = imageFromURL
                }
            }
        }
        
        titleLabel.text = game.name
        releaseDateLabel.text = "Release date: \(game.released ?? "-")"
        
        let descriptionAttributedText = game.description?.htmlFormattedAttributedString()
        descriptionLabel.attributedText = descriptionAttributedText
        
        ratingAndPlayedLabel.text = "⭐️ \(game.rating) 🎮 \(game.playtime)"
    }
    
    func setLoadingState(_ isLoading: Bool) {
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        
        loadingIndicator.isHidden = !isLoading
        bannerImageView.isHidden = isLoading
        infoStackView.isHidden = isLoading
        descriptionLabel.isHidden = isLoading
    }
}
