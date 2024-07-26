//
//  SerieFavoritesViewControler.swift
//  Movies
//
//  Created by ios-noite-13 on 09/07/24.
//

import UIKit

class SerieFavoritesViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Services
    var serieFavoriteService = SerieFavoriteService.shared
    
    // Search
    private let searchController = UISearchController()
    private var serie: [Series] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serie = serieFavoriteService.listAll()
        tableView.reloadData()
    }
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        serie = serieFavoriteService.listAll()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SerieTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SerieTableViewCell.identifier)
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension SerieFavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        serie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SerieTableViewCell.identifier, for: indexPath) as? SerieTableViewCell else {
            return UITableViewCell()
        }
        
        let serie = serie[indexPath.row]
        
        cell.delegate = self
        cell.setup(serie: serie)
        return cell
    }
}

// MARK: - SerieTableViewCellDelegate

extension SerieFavoritesViewController: SerieTableViewCellDelegate {
    func didTapFavoriteButton(forSerie serie: Series) {
        self.serie.removeAll(where: { $0 == serie })
        serieFavoriteService.removeSerie(withId: serie.id)
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension SerieFavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            serie = serieFavoriteService.listAll()
        } else {
            serie = filteredSerie(byTitle: searchText)
        }
        
        tableView.reloadData()
    }
    
    private func filteredSerie(byTitle serieTitle: String) -> [Series] {
        serieFavoriteService.listAll().filter({ serie in
            serie.title.contains(serieTitle)
        })
    }
}
