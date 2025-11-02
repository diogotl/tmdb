//
//  TMDBService.swift
//  tmdb
//
//  Created by Diogo on 19/10/2025.
//

import Foundation

// MARK: - Models
class MovieResponse: Decodable {
    var results: [Movie]
}

class TMDBService {
    static let shared = TMDBService()

    private let baseURL = "https://api.themoviedb.org/3"

    private init() {}

    private var bearerToken: String? {
        if let token = Bundle.main.infoDictionary?["TMDB_BEARER_TOKEN"] as? String, !token.isEmpty {
            return token
        }
        return ProcessInfo.processInfo.environment["TMDB_BEARER_TOKEN"]
    }

    // MARK: - Movies
    func fetchPopularMovies(completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/movie/popular") else {
            completion(.failure(NSError(domain: "URL inválida", code: 0)))
            return
        }

        guard let token = bearerToken else {
            completion(.failure(NSError(domain: "Token não encontrado", code: 1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Resposta inválida", code: 0)))
                    return
                }

                guard 200...299 ~= httpResponse.statusCode else {
                    completion(
                        .failure(NSError(domain: "Erro HTTP", code: httpResponse.statusCode)))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "Sem dados", code: 3)))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decoded = try decoder.decode(MovieResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func searchMovies(
        query: String, completion: @escaping (Result<MovieResponse, Error>) -> Void
    ) {
        guard
            let url = URL(
                string:
                    "\(baseURL)/search/movie?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            )
        else {
            completion(.failure(NSError(domain: "URL inválida", code: 0)))
            return
        }

        guard let token = bearerToken else {
            completion(.failure(NSError(domain: "Token não encontrado", code: 1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Resposta inválida", code: 0)))
                    return
                }

                guard 200...299 ~= httpResponse.statusCode else {
                    completion(
                        .failure(
                            NSError(domain: "Erro HTTP", code: httpResponse.statusCode))
                    )
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "Sem dados", code: 3)))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decoded = try decoder.decode(MovieResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
