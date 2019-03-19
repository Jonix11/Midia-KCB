//
//  MediaItemDetailedProvidable.swift
//  Midia
//
//  Created by Jon Gonzalez on 11/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

protocol MediaItemDetailedProvidable {
    
    var mediaItemId: String { get }
    var title: String { get }
    var imageURL: URL? { get }
    var creatorsName: String? { get }
    var rating: Float? { get }
    var numberOfReviews: Int? { get }
    var creationDate: Date? { get }
    var price: Float? { get }
    var description: String? { get }
    
}
