//
//  RootCoordinator.swift
//  tmdb
//
//  Created by Diogo on 26/10/2025.
//

import Foundation
import UIKit

class RootCoordinator {
    private var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    public init() {
        self.viewControllerFactory = ViewControllersFactory()
    }
    
    func start() -> UINavigationController? {
        let startViewController = viewControllerFactory.makeHomeViewController(
            coordinator: self
        )
        
        self.navigationController = UINavigationController(rootViewController: startViewController)
        
        return navigationController;
    }
}

extension RootCoordinator: HomeViewCoordinatorDelegate {
    func navigateToMovieDetails(id: Int) {
        
        let movieDetailsViewController = viewControllerFactory.makeMovieDetailsViewController(id: id)
        
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}
