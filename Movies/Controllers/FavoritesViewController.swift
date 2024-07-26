//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Services
    var favoriteService = FavoriteService.shared
    var serieFavoriteService = SerieFavoriteService.shared
    
    // Search
    private let searchController = UISearchController()
    private var movies: [Movie] = []
    private var series: [Series] = []
    private var favorites: [Favorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movies = favoriteService.listAll()
        series = serieFavoriteService.listAll()
        favorites = movies.map { Favorite(id: $0.id, title: $0.title, genre: $0.genre, posterURL: $0.posterURL, type: .movie) } + series.map { Favorite(id: $0.id, title: $0.title, genre: $0.genre, posterURL: $0.posterURL, type: .serie) }
        tableView.reloadData()
    }
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let favorite = favorites[indexPath.row]
        
        cell.delegate = self
        cell.setup(favorite: favorite)
        return cell
    }
}

// MARK: - MovieTableViewCellDelegate

extension FavoritesViewController: MovieTableViewCellDelegate {
    func didTapFavoriteButton(forFavorite favorite: Favorite) {
        favorites.removeAll(where: { $0 == favorite })
        switch favorite.type {
        case .movie:
            favoriteService.removeMovie(withId: favorite.id)
        case .serie:
            serieFavoriteService.removeSerie(withId: favorite.id)
        }
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension FavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            movies = favoriteService.listAll()
        } else {
            movies = filteredMovies(byTitle: searchText)
        }
        
        tableView.reloadData()
    }
    
    private func filteredMovies(byTitle movieTitle: String) -> [Movie] {
        favoriteService.listAll().filter({ movie in
            movie.title.contains(movieTitle)
        })
    }
}
