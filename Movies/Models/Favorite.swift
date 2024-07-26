//
//  Favorite.swift
//  Movies
//
//  Created by ios-noite-03 on 25/07/24.
//

import Foundation

enum FavoriteType {
    case movie, serie
}

struct Favorite: Equatable {
    let id: String
    let title: String
    let genre: String?
    let posterURL: String?
    let type: FavoriteType

}
