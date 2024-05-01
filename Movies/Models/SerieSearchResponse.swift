//
//  SerieSearchResponse.swift
//  Movies
//
//  Created by lucas vizeu on 30/04/24.
//

import Foundation

struct SeriesSearchResponse: Decodable {
    let search: [Series]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
