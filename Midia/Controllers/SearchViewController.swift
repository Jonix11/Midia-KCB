//
//  SearchViewController.swift
//  Midia
//
//  Created by Jon Gonzalez on 05/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let mediaItemCellReuseIdentifier = "mediaItemCellIdentifier"
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mediaItemChanger: UISegmentedControl!
    
    // MARK: Actions
    @IBAction func changeMediaItem(_ sender: Any) {
        if mediaItemChanger.selectedSegmentIndex == 0 {
            mediaItemProvider = MediaItemProvider(withMediaItemKind: .book)
        } else {
            mediaItemProvider = MediaItemProvider(withMediaItemKind: .movie)
        }
        
        if searchBar.text?.count == 0 {
            mediaItems = []
            collectionView.reloadData()
        } else {
            loadMediaItems()
        }
        
    }
    
    var mediaItemProvider: MediaItemProvider!
    var mediaItems: [MediaItemProvidable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaItemCellReuseIdentifier, for: indexPath) as? MediaItemCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        let mediaItem = mediaItems[indexPath.item]
        cell.mediaItem = mediaItem
        
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Creamos el detail VC
        guard let detailViewController = UIStoryboard(name: "NewDetail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            fatalError()
        }
        
        // Le pasamos la información (id, mediaprovider)
        let mediaItem = mediaItems[indexPath.item]
        detailViewController.mediaItemId = mediaItem.mediaItemId
        detailViewController.mediaItemProvider = mediaItemProvider
        detailViewController.mediaKind = mediaItemProvider.mediaItemKind
        // Lo mostramos
        // Muestra, en este caso un detailViewController, de manera modal, es decir, sin un navigationController
        // Ocupa toda la pantalla
        present(detailViewController, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         loadMediaItems()
        
    }
}

extension SearchViewController {
    private func loadMediaItems() {
        guard let queryParams = searchBar.text, !queryParams.isEmpty else {
            return
        }
        activityIndicator.isHidden = false
        mediaItemProvider.getSearchMediaItems(withQueryParams: queryParams, success: { [weak self] (mediaItems) in
            self?.mediaItems = mediaItems
            self?.collectionView.reloadData()
            self?.activityIndicator.isHidden = true
        }) { (error) in
            // TODO
        }
    }
}
