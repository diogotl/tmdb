//
//  HomeViewModel.swift
//  tmdb
//
//  Created by Diogo on 09/10/2025.
//

import Foundation

class HomeViewModel {
    
    private(set) var movies: [Movie] = []
    
    // Callbacks de binding que o Controller "escuta"
    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    class MovieResponse: Decodable  {
        var results: [Movie]
    }
    
    private let baseURL = "https://api.themoviedb.org/3"
    
    private var bearerToken: String? {
        if let token = Bundle.main.infoDictionary?["TMDB_BEARER_TOKEN"] as? String, !token.isEmpty {
            return token
        }
        return ProcessInfo.processInfo.environment["TMDB_BEARER_TOKEN"]
    }
    
    // Única função pública: faz a requisição, atualiza o estado e dispara os callbacks armazenados
    func fetchMovies() {
        guard let url = URL(string: "\(baseURL)/movie/popular") else {
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
                let decoded = try decoder.decode(MovieResponse.self, from: data)
                self.movies = decoded.results
                self.onMoviesUpdated?()
            } catch {
                self.onError?(error)
            }
        }.resume()
    }
}
