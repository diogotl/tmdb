//
//  Movie.swift
//  tmdb
//
//  Created by Diogo on 09/10/2025.
//

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let voteAverage: Double
}
