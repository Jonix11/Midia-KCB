//
//  MediaItemCollectionViewCell.swift
//  Midia
//
//  Created by Jon Gonzalez on 27/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import UIKit
import SDWebImage

class MediaItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var mediaItem: MediaItemProvidable! {
        didSet {
            titleLabel.text = mediaItem.title
            if let url = mediaItem.imageURL {
                //imageView.loadImage(fromURL: url)
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.sd_cancelCurrentImageLoad()
    }
}
