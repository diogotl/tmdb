//
//  UITableViewCell.swift
//  tmdb
//
//  Created by Diogo on 16/10/2025.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieTableViewCell"
    
    private let imagePoster: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .tertiarySystemFill
        iv.layer.cornerRadius = 6
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, overviewLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imagePoster, textStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16.0
        stack.alignment = .top
        stack.distribution = .fill
        return stack
    }()
    
    // Para evitar race conditions com reutilização de células
    private var currentImageURL: URL?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Limpa imagem e URL atual para evitar imagens trocadas
        imagePoster.image = nil
        currentImageURL = nil
    }
    
    private func setupViews() {
        contentView.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        let spacing: CGFloat = 12
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            
            imagePoster.widthAnchor.constraint(equalToConstant: 80),
            imagePoster.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        imagePoster.setContentHuggingPriority(.required, for: .horizontal)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview.isEmpty ? "Sem descrição." : movie.overview
        
        // Monta a URL do poster do TMDB (tamanho w500 é bem comum)
        if let path = movie.posterPath, !path.isEmpty,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            currentImageURL = url
            imagePoster.image = nil // opcional: placeholder
            
            ImageLoader.shared.load(url: url) { [weak self] image in
                guard let self = self else { return }
                // Garante que a resposta ainda corresponde a esta célula
                if self.currentImageURL == url {
                    self.imagePoster.image = image
                }
            }
        } else {
            currentImageURL = nil
            imagePoster.image = nil
        }
    }
}
