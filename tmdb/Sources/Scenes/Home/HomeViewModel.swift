//
//  HomeViewModel.swift
//  tmdb
//
//  Created by Diogo on 09/10/2025.
//

import Foundation

class HomeViewModel {

    private(set) var movies: [Movie] = []
    private(set) var isLoading: Bool = false

    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?

    private func setLoading(_ loading: Bool) {
        isLoading = loading
        onLoadingChanged?(loading)
    }

    func fetchMovies() {
        setLoading(true)

        TMDBService.shared.fetchPopularMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.setLoading(false)

                switch result {
                case .success(let response):
                    self.movies = response.results
                    self.onMoviesUpdated?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }

    func searchMovies(query: String) {
        setLoading(true)

        TMDBService.shared.searchMovies(query: query) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.setLoading(false)

                switch result {
                case .success(let response):
                    self.movies = response.results
                    self.onMoviesUpdated?()
                case .failure(let error):
                    self.onError?(error)
                }
            }
        }
    }
}
