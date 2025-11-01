//
//  MovieDetailsViewController.swift
//  tmdb
//
//  Created by Diogo on 22/10/2025.
//

import UIKit
import Foundation

class MovieDetailsViewController: UIViewController {
    
    let viewContent: MovieDetailsView
    let viewModel: MovieDetailsViewModel
    
    init(
        viewContent: MovieDetailsView,
        viewModel: MovieDetailsViewModel
    ) {
        self.viewContent = viewContent
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        view.addSubview(viewContent)
        view.backgroundColor = .systemBackground
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: view.topAnchor),
            viewContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewContent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDetailsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchDetails()
    }
    
    private func updateUI() {
        if let details = viewModel.details {
            title = details.title
            // Importante: atualiza a view com os dados
            viewContent.configure(with: details)
        }
    }
}
