//
//  HomeViewController.swift
//  tmdb
//
//  Created by Diogo on 08/10/2025.
//
import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    let contentView: HomeView
    let viewModel: HomeViewModel
    let flowDelegate: HomeViewCoordinatorDelegate
    
    init(
        contentView: HomeView,
        viewModel: HomeViewModel,
        flowDelegate: HomeViewCoordinatorDelegate
    ) {
        self.contentView = contentView
        self.viewModel = viewModel
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Título via Navigation Bar (padrão do iOS)
        navigationItem.title = "Movies"
        // Se quiser large titles, descomente a linha abaixo:
        // navigationController?.navigationBar.prefersLargeTitles = true
        
        setupView()
        bindViewModel()
        loadMovies()
    }
    
    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.contentView.tableView.reloadData()
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
    
    private func loadMovies() {
        viewModel.fetchMovies()
    }
    
    func setupView() {
        view.addSubview(contentView)
        view.backgroundColor = .systemBackground
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        flowDelegate.navigateToMovieDetails(id: movie.id)
    }
}

