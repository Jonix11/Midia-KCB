//
//  FavoritesProvidable.swift
//  Midia
//
//  Created by Jon Gonzalez on 11/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

protocol FavoritesProvidable {
    
    func getFavorites() -> [MediaItemDetailedProvidable]?
    func getFavorite(byId favoriteId: String) -> MediaItemDetailedProvidable?
    func add(favorite: MediaItemDetailedProvidable)
    func remove(favoriteWithId favoriteId: String)
    
}
