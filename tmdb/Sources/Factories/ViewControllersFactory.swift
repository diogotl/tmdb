//
//  ViewControllersFactory.swift
//  tmdb
//
//  Created by Diogo on 23/10/2025.
//

import Foundation
import UIKit

class ViewControllersFactory: ViewControllersFactoryProtocol {
    func makeHomeViewController(
        coordinator: HomeViewCoordinatorDelegate
    ) -> HomeViewController {
        let contentView = HomeView()
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(
            contentView: contentView,
            viewModel: viewModel,
            flowDelegate: coordinator
        )
        
        return viewController
    }
    
    func makeMovieDetailsViewController(id: Int) -> MovieDetailsViewController {
        let contentView = MovieDetailsView()
        let viewModel = MovieDetailsViewModel(movieId: id)
        let viewController = MovieDetailsViewController(
            viewContent: contentView,
            viewModel: viewModel
        )
        
        return viewController
    }
}
