//
//  StorageManager.swift
//  Midia
//
//  Created by Jon Gonzalez on 11/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

class StorageManager {
    //static let shared: FavoritesProvidable = UserDefaultStorageManager(withMediaItemKind: .movie)
    static let shared: FavoritesProvidable = CoreDataStorageManager(withMediaItemKind: .book)
}
