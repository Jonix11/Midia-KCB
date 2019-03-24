//
//  FavoritesViewController.swift
//  Midia
//
//  Created by Jon Gonzalez on 11/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mediaItemChanger: UISegmentedControl!
    
    // MARK: Actions
    @IBAction func changeMediaItem(_ sender: Any) {
        loadMediaItems()
    }
    let favoriteCellReuseIdentifier = "favoriteCellReuseIdentifier"
    
    var favorites: [MediaItemDetailedProvidable] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMediaItems()
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "NewDetail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            fatalError()
        }
        
        let mediaItem = favorites[indexPath.row]
        detailViewController.mediaItemId = mediaItem.mediaItemId
        if mediaItemChanger.selectedSegmentIndex == 0 {
            detailViewController.mediaKind = .book
        } else {
            detailViewController.mediaKind = .movie
        }

        present(detailViewController, animated: true, completion: nil)
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: favoriteCellReuseIdentifier) as? FavoriteTableViewCell else {
            fatalError()
        }
        cell.mediaItem = favorites[indexPath.row]
        return cell
    }
    
    
}

extension FavoritesViewController {
    private func loadMediaItems() {
        if mediaItemChanger.selectedSegmentIndex == 0 {
            if let storedFavorites = StorageManager.sharedBook.getFavorites() {
                favorites = storedFavorites
                tableView.reloadData()
            }
        } else {
            if let storedFavorites = StorageManager.sharedMovie.getFavorites() {
                favorites = storedFavorites
                tableView.reloadData()
            }
        }
    }
}
