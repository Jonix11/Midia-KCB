//
//  Game.swift
//  Midia
//
//  Created by Jon Gonzalez on 28/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

struct Game: MediaItemProvidable, MediaItemDetailedProvidable{
    
    let mediaItemId: String = "1234"
    let title: String = "A game"
    let imageURL: URL? = nil
    let creatorsName: String? = nil
    let rating: Float? = nil
    let numberOfReviews: Int? = nil
    let creationDate: Date? = nil
    let price: Float? = nil
    let description: String? = nil
    
}
