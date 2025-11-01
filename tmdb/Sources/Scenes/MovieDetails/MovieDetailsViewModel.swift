//
//  MovieDetailsViewModel.swift
//  tmdb
//
//  Created by Diogo on 26/10/2025.
//

import Foundation

class MovieDetailsViewModel {
    
    struct MovieDetails: Decodable {
        let id: Int
        let title: String
        let overview: String
        let releaseDate: String
        let posterPath: String?
        let voteAverage: Double
    }
    
    private let movieId: Int
    private let baseURL = "https://api.themoviedb.org/3"
    
    private var bearerToken: String? {
        if let token = Bundle.main.infoDictionary?["TMDB_BEARER_TOKEN"] as? String, !token.isEmpty {
            return token
        }
        return ProcessInfo.processInfo.environment["TMDB_BEARER_TOKEN"]
    }
    
    private(set) var details: MovieDetails?
    
    var onDetailsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func fetchDetails() {
        guard let url = URL(string: "\(baseURL)/movie/\(movieId)") else {
            onError?(NSError(domain: "URL inválida", code: 0))
            return
        }
        
        guard let token = bearerToken else {
            onError?(NSError(domain: "Token não encontrado", code: 1))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            
            if let error = error {
                self.onError?(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                self.onError?(NSError(domain: "Erro HTTP", code: 2))
                return
            }
            guard let data = data else {
                self.onError?(NSError(domain: "Sem dados", code: 3))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(MovieDetails.self, from: data)
                self.details = decoded
                self.onDetailsUpdated?()
            } catch {
                self.onError?(error)
            }
        }.resume()
    }
}

