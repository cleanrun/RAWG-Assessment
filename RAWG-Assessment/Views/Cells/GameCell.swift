//
//  GameCell.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 15/08/23.
//

import UIKit

final class GameCell: UITableViewCell, ReusableView {
    
    static let CELL_HEIGHT: CGFloat = 100
    
    private lazy var thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private(set) var representedID: UUID?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
    }
    
    private func setupContents() {
        contentView.addSubviews(thumbnailImage, infoStackView)
        infoStackView.addArrangedSubviews(titleLabel, releaseDateLabel, ratingLabel)
        
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            thumbnailImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            thumbnailImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            thumbnailImage.widthAnchor.constraint(equalToConstant: 100),
            
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            infoStackView.leftAnchor.constraint(equalTo: thumbnailImage.rightAnchor, constant: 16),
            infoStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
    }
    
    func setData(_ game: Game) {
        titleLabel.text = game.name
        releaseDateLabel.text = "Release date: \(game.released ?? "-")"
        ratingLabel.text = "⭐️ \(game.rating)"
    }
    
    func updateImage(_ image: UIImage?) {
        thumbnailImage.image = image
    }

}
