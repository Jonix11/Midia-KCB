//
//  MovieCollection.swift
//  Midia
//
//  Created by Jon Gonzalez on 20/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

struct MovieCollection {
    let resultCount: Int
    let results: [Movie]?
}

extension MovieCollection: Decodable {
    
}
