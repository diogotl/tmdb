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

    private var searchTimer: Timer?

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

        print("hue")

        setupView()
        bindViewModel()
        loadMovies()
    }

    private func bindViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            self?.contentView.tableView.reloadData()
        }

        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(
                title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.onLoadingChanged = { [weak self] isLoading in
            self?.contentView.showLoading(isLoading)
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
        contentView.tableView.register(
            MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        contentView.tableView.register(
            SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseIdentifier)
        contentView.tableView.register(
            EmptyStateCell.self, forCellReuseIdentifier: EmptyStateCell.reuseIdentifier)
        contentView.searchBar.delegate = self

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isLoading {
            return 8
        }

        if viewModel.movies.isEmpty {
            return 1
        }

        return viewModel.movies.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        if viewModel.isLoading {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SkeletonCell.reuseIdentifier, for: indexPath)
            return cell
        }

        if viewModel.movies.isEmpty {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: EmptyStateCell.reuseIdentifier, for: indexPath)

            if let emptyCell = cell as? EmptyStateCell {
                emptyCell.configure(message: "Nenhum filme encontrado.", icon: "")
                emptyCell.selectionStyle = .none
                emptyCell.backgroundColor = .systemBackground
                emptyCell.contentView.backgroundColor = .systemBackground
            }

            return cell
        }

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath)
                as? MovieTableViewCell
        else {
            return UITableViewCell()
        }
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isLoading || viewModel.movies.isEmpty {
            return
        }

        let movie = viewModel.movies[indexPath.row]
        flowDelegate.navigateToMovieDetails(id: movie.id)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !query.isEmpty {
            print("🔍 Buscar por: \(query)")
            viewModel.searchMovies(query: query)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        print("❌ Busca cancelada")
        viewModel.fetchMovies()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("✏️ Texto alterado: \(searchText)")

        // Cancel previous timer
        searchTimer?.invalidate()

        if searchText.isEmpty {
            viewModel.fetchMovies()
        } else {
            // Start new timer - search after 1 second of no typing
            searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {
                [weak self] _ in
                print("🔍 Auto-search por: \(searchText)")
                self?.viewModel.searchMovies(query: searchText)
            }
        }
    }
}
