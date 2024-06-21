//
//  SeriesDetailViewControler.swift
//  Movies
//
//  Created by ios-noite-13 on 20/06/24.
//

import UIKit

class SerieDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var movieFavoriteButton: UIBarButtonItem!
    
    @IBOutlet weak var serieTitleLabel: UILabel!
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieGenreLabel: UILabel!
    @IBOutlet weak var serieSeasonLabel: UILabel!
    @IBOutlet weak var serieEpisodeLabel: UILabel!
    @IBOutlet weak var serieCountryLabel: UILabel!
    @IBOutlet weak var serieReleasedLabel: UILabel!
    @IBOutlet weak var serieLanguageLabel: UILabel!
    @IBOutlet weak var seriePlotLabel: UILabel!

    
    // Services
    let breakingBad = gerarBreakingBad()
    var serieService = SeriesService()
    var favoriteService = FavoriteService.shared
    
    
    
    // Data
    var serieId: String?
    var serieTitle: String?
    private var serie: Series?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serieTitleLabel.text = serieTitle
        loadMovieData()
    }
    
    private func loadMovieData() {
        guard let serieId = serieId else { return }
        
        serieService.searchSeries(withId: serieId) {serie in
            
            self.serie = serie
            
            // Load movie image
            if let posterURL = serie?.posterURL {
                self.serieService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateMovieImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewData()
            }
        }
    }
    
    private func updateViewData() {
        movieGenreLabel.text = movie?.genre
        movieCountryLabel.text = movie?.country
        movieLanguageLabel.text = movie?.language
        movieReleasedLabel.text = movie?.released
        moviePlotLabel.text = movie?.plot
        updateFavoriteButton()
    }
    
   
    
    private func updateMovieImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let movieImage = UIImage(data: imageData)
            self.movieImageView.image = movieImage
        }
    }
    
  @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let movie = movie else { return }
        
        if movie.isFavorite {
            // Remove movie from favorite list
            favoriteService.removeMovie(withId: movie.id)
        } else {
            // Add movie to favorite list
            favoriteService.addMovie(movie)
        }
        
        updateFavoriteButton()
    }
}
