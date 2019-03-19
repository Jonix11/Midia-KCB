//
//  BookCollection.swift
//  Midia
//
//  Created by Jon Gonzalez on 26/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

struct BookCollection {
    
    let kind: String
    let totalItems: Int
    let items: [Book]?
    
}

extension BookCollection: Decodable {
    
}
