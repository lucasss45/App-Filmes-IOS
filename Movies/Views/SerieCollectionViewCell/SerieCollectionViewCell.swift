//
//  SerieCollectionViewCell.swift
//  Movies
//
//  Created by ios-noite-03 on 18/06/24.
//

import Foundation

import UIKit

class SeriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "seriesCollectionCell"
    
    // Outlets
    @IBOutlet weak var seriesImageView: UIImageView!
    @IBOutlet weak var seriesTitleLabel: UILabel!
    
    private let seriesService = SerieService()
    
    func setup(series: Series) {
        seriesImageView.layer.masksToBounds = true
        seriesImageView.layer.cornerRadius = 8
        seriesImageView.layer.borderWidth = 1
        seriesImageView.layer.borderColor = UIColor.black.cgColor
        
        // Clean data
        seriesImageView.image = nil
        seriesTitleLabel.text = nil
        
        // Load series poster from URL
        if let posterPath = series.posterURL {
            seriesService.loadImageData(fromURL: posterPath) { imageData in
                self.updateCell(withImageData: imageData, orTitle: series.title)
            }
        }
    }
    
    func updateCell(withImageData imageData: Data?, orTitle title: String) {
        DispatchQueue.main.async {
            if let imageData = imageData {
                // Show series image
                let seriesImage = UIImage(data: imageData)
                self.seriesImageView.image = seriesImage
            } else {
                // Show series title if poster is not available
                self.seriesTitleLabel.text = title
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seriesImageView.image = nil
        seriesTitleLabel.text = nil
    }
}


