//
//  StorageManager.swift
//  Midia
//
//  Created by Jon Gonzalez on 11/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

class StorageManager {
    
    //static let sharedBook: FavoritesProvidable = UserDefaultStorageManager(withMediaItemKind: .book)
    static let sharedBook: FavoritesProvidable = CoreDataStorageManager(withMediaItemKind: .book)
    
    //static let sharedMovie: FavoritesProvidable = UserDefaultStorageManager(withMediaItemKind: .movie)
    static let sharedMovie: FavoritesProvidable = CoreDataStorageManager(withMediaItemKind: .movie)
    
    
}
