//
//  SeriesDetailViewControler.swift
//  Movies
//
//  Created by ios-noite-13 on 20/06/24.
//

import UIKit

class SerieDetailViewController: UIViewController {
    
    // Outlets
   
    @IBOutlet weak var FavoriteButton: UIBarButtonItem!
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
    var serieService = SeriesService()
    var favoriteService = FavoriteService.shared
    
    
    
    // Data
    var serieId: String?
    var serieTitle: String?
    private var serie: Series?
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        serieTitleLabel.text = serieTitle
        loadSerieData()
    }
    
    private func loadSerieData() {
        guard let serieId = serieId else { return }
     
        serieService.searchSeries(withId: serieId) {serie in
            
            self.serie = serie
            
            //Load; serie; image
            if let posterURL = serie?.posterURL {
                self.serieService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateSerieImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewData()
            }
        }
    }
    
    private func updateViewData() {
        serieTitleLabel.text = serie?.title
        serieGenreLabel.text = serie?.genre
        serieSeasonLabel.text = serie?.season
        serieEpisodeLabel.text = serie?.episode
        serieCountryLabel.text = serie?.country
        serieLanguageLabel.text = serie?.language
        serieReleasedLabel.text = serie?.released
        seriePlotLabel.text = serie?.plot
        updateFavoriteButton()
  }
    

    //favorite section
    
    private func updateFavoriteButton() {
        guard let serie = serie else { return }
        
        let isFavorite = favoriteService.isFavorite(serieId: serie.id)
       self.serie?.isFavorite = isFavorite
        let favoriteIcon = isFavorite ? "heart.fill" : "heart"
        FavoriteButton.image = .init(systemName: favoriteIcon)
    }
    
    private func updateSerieImage(withImageData imageData: Data?) {
       guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
           let serieImage = UIImage(data: imageData)
            self.serieImageView.image = serieImage
        }
    }
    
    
           func didTapFavoriteButton(_ sender: Any) {
       guard let serie = serie else { return }
        
        if serie.isFavorite {
            //Remove movie from favorite list
            favoriteService.removeSerie(withId: serie.id)
        } else {
             //Add movie to favorite list
           favoriteService.addSerie(serie)
        }
        updateFavoriteButton()
    }
}

