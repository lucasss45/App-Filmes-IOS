//
//  MovieListViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class MovieListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    private let emptyStateLabel: UILabel = {
            let label = UILabel()
            label.text = "Nenhum resultado encontrado"
            label.textAlignment = .center
            label.isHidden = true
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 24)
            return label
        }()
    
    // Services
    var movieService = MovieService()
    
        	// Search
    private let searchController = UISearchController()
    private let defaultSearchName = ""
    private var movies: [Movie] = []
    private let segueIdentifier = "showMovieDetailVC"
    
    // Collection item parameters
    private let itemsPerRow = 2.0
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupEmptyStateLabel()
        loadMovies(withTitle: defaultSearchName)
    }
    
    private func setupViewController() {
        setupSearchController()
        setupCollectionView()
    }
    
    private func setupEmptyStateLabel() {
            view.addSubview(emptyStateLabel)
            NSLayoutConstraint.activate([
                emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func loadMovies(withTitle movieTitle: String) {
            if movieTitle.isEmpty {
                movies.removeAll()
                collectionView.reloadData()
                updateEmptyStateLabel(withMessage: "Busque um filme")
            } else {
                movieService.searchMovies(withTitle: movieTitle) { movies in
                    DispatchQueue.main.async {
                        self.movies = movies
                        self.updateEmptyStateLabel()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    
    private func updateEmptyStateLabel(withMessage message: String? = nil) {
            if let message = message {
                emptyStateLabel.text = message
                emptyStateLabel.isHidden = false
            } else {
                emptyStateLabel.text = "Nenhum resultado encontrado"
                emptyStateLabel.isHidden = !movies.isEmpty
            }
        }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetailVC = segue.destination as? MovieDetailViewController,
              let movie = sender as? Movie else {
            return
        }
        
        movieDetailVC.movieId = movie.id
        movieDetailVC.movieTitle = movie.title
    }
}

// MARK: - UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.setup(movie: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionWidth = collectionView.frame.size.width - marginSize
        let availableWidth = collectionWidth - (spaceBetweenItems * itemsPerRow)
        
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = itemWidth * itemAspectRatio
        
        return .init(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UICollectionViewDelegate

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedMovie)
    }
}

// MARK: - UISearchResultsUpdating

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        loadMovies(withTitle: searchText)
    }
}
