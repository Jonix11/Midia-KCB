//
//  MediaItemProvidable.swift
//  Midia
//
//  Created by Jon Gonzalez on 28/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

protocol MediaItemProvidable {
    
    var mediaItemId: String { get }
    var title: String { get }
    var imageURL: URL? { get }
    
}
