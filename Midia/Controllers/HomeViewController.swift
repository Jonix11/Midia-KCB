//
//  HomeViewController.swift
//  Midia
//
//  Created by Jon Gonzalez on 26/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit

enum MediaItemViewControllerState {
    case loading
    case noResult
    case failure
    case ready
}

class HomeViewController: UIViewController {
    
    let mediaItemCellIdentifier = "mediaItemCell"
    
    var mediaItemProvider: MediaItemProvider!
    private var mediaItems: [MediaItemProvidable] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var failureEmojiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var state: MediaItemViewControllerState = .ready {
        willSet {
            guard state != newValue else { return }
            
            // Cuando el valor haya cambiado, actualizamos la vista
            // Ocultamos todas las vistas relacionadas con los estados y después mostramos las que corresponden
            [collectionView, activityIndicatorView, failureEmojiLabel, statusLabel].forEach { (view) in
                view?.isHidden = true
            }
            
            switch newValue {
            case .loading:
                activityIndicatorView.isHidden = false
            case .noResult:
                failureEmojiLabel.isHidden = false
                failureEmojiLabel.text = "☹️"
                statusLabel.isHidden = false
                statusLabel.text = "No hay nada que mostrar!!"
            case .failure:
                failureEmojiLabel.isHidden = false
                failureEmojiLabel.text = "❌"
                statusLabel.isHidden = false
                statusLabel.text = "Error conectando!!"
            case .ready:
                collectionView.isHidden = false
                collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        state = .loading
        mediaItemProvider.getHomeMediaItems(onSuccess: { [weak self] (mediaItems) in
            self?.mediaItems = mediaItems
            self?.state = mediaItems.count > 0 ? .ready : .noResult
            // La línea de arriba hace lo mismo que el if else de abajo comentado
//            if mediaItems.count > 0 {
//                self?.state = .ready
//            } else {
//                self?.state = .noResult
//            }
        }, failure: { [weak self] (error) in
            self?.state = .failure
        })
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Creamos el detail VC
        guard let detailViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            fatalError()
        }
        
        // Le pasamos la información (id, mediaprovider)
        let mediaItem = mediaItems[indexPath.item]
        detailViewController.mediaItemId = mediaItem.mediaItemId
        detailViewController.mediaItemProvider = mediaItemProvider
        // Lo mostramos
        // Muestra, en este caso un detailViewController, de manera modal, es decir, sin un navigationController
        // Ocupa toda la pantalla
        present(detailViewController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaItemCellIdentifier, for: indexPath) as? MediaItemCollectionViewCell else {
            fatalError()
        }
        
        let mediaItem = mediaItems[indexPath.item]
        
        cell.mediaItem = mediaItem
        
        return cell
        
    }
    
    
}