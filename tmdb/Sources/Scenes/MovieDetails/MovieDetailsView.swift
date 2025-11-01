//
//  MovieDetailsView.swift
//  tmdb
//
//  Created by Diogo on 22/10/2025.
//

import Foundation
import UIKit

class MovieDetailsView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .tertiarySystemFill
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let infoStack = UIStackView()
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupConstraints()
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        infoStack.axis = .vertical
        infoStack.spacing = 6
        infoStack.alignment = .leading
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStack)
        contentStack.addArrangedSubview(posterImageView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(infoStack)
        contentStack.addArrangedSubview(overviewLabel)
        
        infoStack.addArrangedSubview(releaseDateLabel)
        infoStack.addArrangedSubview(voteAverageLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configure(with details: MovieDetailsViewModel.MovieDetails) {
        titleLabel.text = details.title
        overviewLabel.text = details.overview.isEmpty ? "Sem descrição." : details.overview
        
        // Data de lançamento
        releaseDateLabel.text = "Lançamento: " + formattedReleaseDate(from: details.releaseDate)
        
        // Nota média
        voteAverageLabel.text = String(format: "Nota: %.1f/10", details.voteAverage)
        
        if let path = details.posterPath, !path.isEmpty,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            ImageLoader.shared.load(url: url) { [weak self] image in
                self?.posterImageView.image = image
            }
        } else {
            posterImageView.image = nil
        }
    }
    
    private func formattedReleaseDate(from string: String) -> String {
        // TMDB normalmente retorna "yyyy-MM-dd"
        let inFormatter = DateFormatter()
        inFormatter.calendar = Calendar(identifier: .iso8601)
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inFormatter.date(from: string) {
            let outFormatter = DateFormatter()
            outFormatter.locale = Locale.current
            outFormatter.dateStyle = .medium // ou .short para dd/MM/aa
            outFormatter.timeStyle = .none
            return outFormatter.string(from: date)
        } else {
            // fallback: mostra a string original
            return string
        }
    }
}
