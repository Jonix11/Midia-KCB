//
//  FavoriteTableViewCell.swift
//  Midia
//
//  Created by Jon Gonzalez on 11/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class FavoriteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorsLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var mediaItem: MediaItemDetailedProvidable! {
        didSet {
            if let url = mediaItem.imageURL {
                coverImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            }
            titleLabel.text = mediaItem.title
            
            // Opcionales, queremos ocultarlos si no existen
            if let creators = mediaItem.creatorsName {
                creatorsLabel.text = creators
            } else {
                creatorsLabel.isHidden = true
            }
            if let date = mediaItem.creationDate {
                createdOnLabel.text = DateFormatter.booksAPIDateFormatter.string(from: date)
            } else {
                createdOnLabel.isHidden = true
            }
            if let price = mediaItem.price {
                priceLabel.text = "Precio: \(price)$"
            } else {
                priceLabel.isHidden = true
            }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.sd_cancelCurrentImageLoad()
        
        // Como hay algunos libros que no tienen fecha o autores... Como ocultamos esos campos
        // al reusar las celdas, tenemos que volver a mostrarlo por si los necesitamos mostrar
        [creatorsLabel, createdOnLabel, priceLabel].forEach { $0?.isHidden = false }
    }
}
