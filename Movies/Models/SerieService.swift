//
//  SerieService.swift
//  Movies
//
//  Created by ios-noite-03 on 18/06/24.
//

import Foundation

class SeriesService {
    
    private let apiKey = "YOUR_API_KEY" //inserir a chave
    private let apibaseURL = "https://api.themoviedb.org/3" //acho que a key ta errada
    
    func searchSeries(withTitle title: String, completion: @escaping ([Series]) -> Void) {
        guard let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(apibaseURL)/search/tv?api_key=\(apiKey)&query=\(query)") else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SeriesResponse.self, from: data)
                completion(response.results)
            } catch {
                completion([])
            }
        }
        task.resume()
    }
    
    func loadImageData(fromPath path: String, completion: @escaping (Data?) -> Void) {
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(path)")!
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            completion(data)
        }
        task.resume()
    }
}

struct SeriesResponse: Decodable {
    let results: [Series]
}
