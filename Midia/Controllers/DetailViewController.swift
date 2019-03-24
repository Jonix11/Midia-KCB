//
//  DetailViewController.swift
//  Midia
//
//  Created by Jon Gonzalez on 05/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var creatorsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var numberOfReviewLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var toggleFavoriteButton: UIButton!
    
    var mediaItemId: String!
    var mediaItemProvider: MediaItemProvider! // Debería ser opcional
    var detailedMediaItem: MediaItemDetailedProvidable?
    var mediaKind: MediaItemKind!
    
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let favorite = StorageManager.sharedBook.getFavorite(byId: mediaItemId) {
            detailedMediaItem = favorite
            syncViewWithModel()
            isFavorite = true
            toggleFavoriteButton.setTitle("Remove favorite", for: .normal)
            loadingView.isHidden = true
        } else {
            if let favorite = StorageManager.sharedMovie.getFavorite(byId: mediaItemId) {
                detailedMediaItem = favorite
                syncViewWithModel()
                isFavorite = true
                toggleFavoriteButton.setTitle("Remove favorite", for: .normal)
                loadingView.isHidden = true
            } else {
                mediaItemProvider.getMediaItem(byId: mediaItemId, success: { [weak self] (detailedMediaItem) in
                    self?.detailedMediaItem = detailedMediaItem
                    self?.syncViewWithModel()
                    self?.loadingView.isHidden = true
                }) { [weak self] (error) in
                    //self?.loadingView.isHidden = true
                    // Creo una alerta, le añado acción con el handler y presento la alerta
                    let alertController = UIAlertController(title: nil, message: "Error recuperando media item", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self?.dismiss(animated: true, completion: nil)
                    }))
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    // MARK: Sync
    private func syncViewWithModel() {
        guard let mediaItem = detailedMediaItem else {
            return
        }
        
        // Campo obligatorio
        titleLabel.text = mediaItem.title
        
        // Me vale que sea nil
        descriptionTextView.text = mediaItem.description
        
        if let url = mediaItem.imageURL {
            imageView.loadImage(fromURL: url)
        }
        
        // Stack view, si lo tenemos lo pintamos, si no ocultamos el elemento para que la stack view se reorganice
        if let creators = mediaItem.creatorsName {
            creatorsLabel.text = creators
        } else {
            creatorsLabel.isHidden = true
        }
        
        if let rating = mediaItem.rating,
            let numberOfReviews = mediaItem.numberOfReviews {
            ratingLabel.text = "Rating \(rating)"
            numberOfReviewLabel.text = "\(numberOfReviews) reviews"
        } else {
            ratingContainerView.isHidden = true
        }
        
        if let creationDate = mediaItem.creationDate {
            switch mediaKind {
            case .book?:
                creationDateLabel.text = "Published on \(DateFormatter.booksAPIDateFormatter.string(from: creationDate))"
            case .movie?:
                creationDateLabel.text = "Released on \(DateFormatter.booksAPIDateFormatter.string(from: creationDate))"
            default:
                creationDateLabel.text = DateFormatter.booksAPIDateFormatter.string(from: creationDate)
            }
        } else {
            creationDateLabel.isHidden = true
        }
        
        if let price = mediaItem.price {
            buyButton.setTitle("Buy for \(price)$", for: .normal)
        } else {
            buyButton.isHidden = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        // Quita la detailViewController de la pantalla
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapToggleFavorite(_ sender: Any) {
        guard let favorite = detailedMediaItem else {
            return
        }
        isFavorite.toggle()
        if isFavorite {
            switch mediaKind {
            case .book?:
                StorageManager.sharedBook.add(favorite: favorite)
            case .movie?:
                StorageManager.sharedMovie.add(favorite: favorite)
            default:
                fatalError("Media item not supported yet")
            }
            
            toggleFavoriteButton.setTitle("Remove favorite", for: .normal)
        } else {
            switch mediaKind {
            case .book?:
                StorageManager.sharedBook.remove(favoriteWithId: favorite.mediaItemId)
            case .movie?:
                StorageManager.sharedMovie.remove(favoriteWithId: favorite.mediaItemId)
            default:
                fatalError("Media item not supported yet")
            }
            toggleFavoriteButton.setTitle("Add favorite", for: .normal)
        }
    }
    
}
