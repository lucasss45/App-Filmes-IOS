//
//  SerieTableViewCell.swift
//  Serie
//
//  Created by ios-noite-13 on 09/07/24.
//

import UIKit

protocol SerieTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(forSerie serie: Series)
}

class SerieTableViewCell: UITableViewCell {
    
    static let identifier = "serieTableCell"
    weak var delegate: SerieTableViewCellDelegate?
    
    // Outlets
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieTitleLabel: UILabel!
    @IBOutlet weak var serieGenreLabel: UILabel!
    
    private let serieService = SeriesService()
    
    // Data
    private var serie: Series?
    
    func setup(serie: Series) {
        self.serie = serie
        serieTitleLabel.text = serie.title
        serieGenreLabel.text = serie.genre ?? "Não definido"
        
        serieImageView.layer.masksToBounds = true
        serieImageView.layer.cornerRadius = 4
        serieImageView.layer.borderWidth = 1
        serieImageView.layer.borderColor = UIColor.black.cgColor
        
        // Load serie poster from URL
        if let posterURL = serie.posterURL {
            serieService.loadImageData(fromURL: posterURL) { imageData in
                DispatchQueue.main.async {
                    let serieImage = UIImage(data: imageData ?? Data())
                    self.serieImageView.image = serieImage
                }
            }
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let serie = serie else { return }
        delegate?.didTapFavoriteButton(forSerie: serie)
    }
}

