//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(forFavorite favorite: Favorite)
}

class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "movieTableCell"
    weak var delegate: MovieTableViewCellDelegate?
    
    // Outlets
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    private let movieService = MovieService()
    private let serieService = SerieService()
    
    // Data
    private var favorite: Favorite?
    
    func setup(favorite: Favorite) {
        self.favorite = favorite
        movieTitleLabel.text = favorite.title
        movieGenreLabel.text = favorite.genre ?? "Não definido"
        
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 4
        movieImageView.layer.borderWidth = 1
        movieImageView.layer.borderColor = UIColor.black.cgColor
        
        // Load movie poster from URL
        if let posterURL = favorite.posterURL {
            switch favorite.type {
            case .movie:
                movieService.loadImageData(fromURL: posterURL) { imageData in
                    DispatchQueue.main.async {
                        let movieImage = UIImage(data: imageData ?? Data())
                        self.movieImageView.image = movieImage
                    }
                }
            case .serie:
                serieService.loadImageData(fromURL: posterURL) { imageData in
                    DispatchQueue.main.async {
                        let serieImage = UIImage(data: imageData ?? Data())
                        self.movieImageView.image = serieImage
                    }
                }
            }
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let favorite = favorite else { return }
        delegate?.didTapFavoriteButton(forFavorite: favorite)
    }
}
