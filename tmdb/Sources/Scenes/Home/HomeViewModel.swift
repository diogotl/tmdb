//
//  HomeViewModel.swift
//  tmdb
//
//  Created by Diogo on 09/10/2025.
//

class HomeViewModel {
    
    public let movies: [Movie] = [
        Movie(id: 1, title: "Órfã 2: A Origem", overview: "", releaseDate: "2022-07-27", posterPath: "", voteAverage: 7.2),
        Movie(id: 2, title: "Minions 2: A Origem de Gru", overview: "", releaseDate: "2022-06-29", posterPath: nil, voteAverage: 7.8),
        Movie(id: 3, title: "Thor: Amor e Trovão", overview: "", releaseDate: "2022-07-06", posterPath: nil,  voteAverage: 6.8),
        Movie(id: 4, title: "Avatar", overview: "",releaseDate: "2009-12-18", posterPath:"", voteAverage: 8.8),
    ]
}
