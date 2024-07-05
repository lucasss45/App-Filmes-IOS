//
//  SeriesLsitViewController.swift
//  Movies
//
//  Created by ios-noite-03 on 18/06/24.
//

import Foundation

import UIKit

class SeriesListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var seriesService = SerieService()
    var series: [Series] = []
    
    private let searchController = UISearchController()
    private let itemsPerRow: CGFloat = 2
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupCollectionView()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Series"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        // Register the nib file for the collection view cell
      
    }
    
    private func searchSeries(withTitle title: String) {
        seriesService.searchSeries(withTitle: title) { [weak self] series in
            DispatchQueue.main.async {
                print(series)
                self?.series = series
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SeriesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        searchSeries(withTitle: searchText)
    }
}

// MARK: - UICollectionViewDataSource

extension SeriesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeriesCollectionViewCell.identifier, for: indexPath) as? SeriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let series = series[indexPath.row]
        cell.setup(series: series)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SeriesListViewController: UICollectionViewDelegateFlowLayout {
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

extension SeriesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle selection
    }
}
