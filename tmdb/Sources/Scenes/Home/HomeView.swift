//
//  HomeView.swift
//  tmdb
//
//  Created by Diogo on 08/10/2025.
//

import Foundation
import UIKit

class HomeView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let homeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Movies"
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none // sem riscas
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    func setupView(){
        self.addSubview(homeTitleLabel)
        self.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            homeTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            homeTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: homeTitleLabel.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

