//
//  HomeViewController.swift
//  tmdb
//
//  Created by Diogo on 08/10/2025.
//
import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    let contentView = HomeView()
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        
        setupConstraints()
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let movie = viewModel.movies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.overview
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}
