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
    private let emptyStateLabel: UILabel = {
            let label = UILabel()
            label.text = "Nenhum resultado encontrado"
            label.textAlignment = .center
            label.isHidden = true
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 24)
            return label
        }()
    
    var seriesService = SerieService()
    var series: [Series] = []
    private let defaultSearchName = ""
    private let segueIdentifier = "showSerieDetailVC"
    
    private let searchController = UISearchController()
    private let itemsPerRow: CGFloat = 2
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupEmptyStateLabel()
        setupCollectionView()
        searchSeries(withTitle: defaultSearchName)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Series"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupEmptyStateLabel() {
            view.addSubview(emptyStateLabel)
            NSLayoutConstraint.activate([
                emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        // Register the nib file for the collection view cell
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let serieDetailVC = segue.destination as? SerieDetailViewController,
              let serie = sender as? Series else {
            return
        }
        
        serieDetailVC.serieId = serie.id
        serieDetailVC.serieTitle = serie.title
    }
    
    private func searchSeries(withTitle title: String) {
        if !InternetConnectionMonitor.shared.isConnected {
            series.removeAll()
            collectionView.reloadData()
            updateEmptyStateLabel(withMessage: "Problema de conexão")
        } else
        if title.isEmpty {
            series.removeAll()
            collectionView.reloadData()
            updateEmptyStateLabel(withMessage: "Busque uma série")
        } else {
            seriesService.searchSeries(withTitle: title) { [weak self] series in
                DispatchQueue.main.async {
                    self?.series = series
                    self?.updateEmptyStateLabel()
                    self?.collectionView.reloadData()
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
                emptyStateLabel.isHidden = !series.isEmpty
            }
        }
}

// MARK: - UISearchResultsUpdating

extension SeriesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//       guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
//            return
//       }
        
        let searchText = searchController.searchBar.text ?? ""
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
        let selectedSerie = series[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedSerie)
    }
}
