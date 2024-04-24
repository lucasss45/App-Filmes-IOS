//
//  Series.swift
//  Movies
//
//  Created by ios-noite-03 on 23/04/24.
//

import Foundation

struct Series: Decodable, Equatable {
    let id: String
    let title: String
    let genre: String?
    let season: Int
    let episode: Int
    let released: String?
    let language: String?
    let country: String?
    let plot: String?
    let posterURL: String?
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case season = "Season"
        case episode = "Episode"
        case released = "Released"
        case language = "Language"
        case country = "Country"
        case genre = "Genre"
        case plot = "Plot"
        case posterURL = "Poster"
    }
}
