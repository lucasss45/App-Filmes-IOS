//
//  SerieService.swift
//  Movies
//
//  Created by ios-noite-03 on 30/04/24.
//

import Foundation

struct SeriesService {

    private let apiBaseURL = "https://www.omdbapi.com/?apikey="
    private let apiToken = ""

    private var apiURL: String {
        apiBaseURL + apiToken
    }

    private let decoder = JSONDecoder()

    func searchSeries(withTitle title: String, completion: @escaping ([Series]) -> Void) {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&s=\(query)&type=series" // Adicionando o parâmetro '&type=series' para buscar apenas séries

        guard let url = URL(string: endpoint) else {
            completion([])
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  error == nil else {
                completion([])
                return
            }

            do {
                let seriesResponse = try decoder.decode(SeriesSearchResponse.self, from: data)
                let series = seriesResponse.search
                completion(series)
            } catch {
                print("FETCH ALL SERIES ERROR: \(error)")
                completion([])
            }
        }

        task.resume()
    }

    func searchSeries(withId seriesId: String, completion: @escaping (Series?) -> Void) {
        let query = seriesId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&i=\(query)&type=series" // Adicionando o parâmetro '&type=series' para buscar apenas séries

        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let series = try decoder.decode(Series.self, from: data)
                completion(series)
            } catch {
                print("FETCH SERIES ERROR: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }

    func loadImageData(fromURL link: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data)
        }

        task.resume()
    }
}
