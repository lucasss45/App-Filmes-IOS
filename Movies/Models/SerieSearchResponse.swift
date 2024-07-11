//
//  SerieSearchResponse.swift
//  Movies
//
//  Created by ios-noite-03 on 18/06/24.
//

//Criar a Resposta de Busca para Séries

import Foundation

struct SeriesSearchResponse: Decodable {
    let search: [Series]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
