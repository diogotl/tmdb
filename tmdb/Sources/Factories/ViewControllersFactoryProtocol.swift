//
//  ViewControllerFactory.swift
//  tmdb
//
//  Created by Diogo on 23/10/2025.
//

protocol ViewControllersFactoryProtocol : AnyObject {
    func makeHomeViewController(
        coordinator: HomeViewCoordinatorDelegate
    ) -> HomeViewController
    func makeMovieDetailsViewController(id:Int) -> MovieDetailsViewController
}
