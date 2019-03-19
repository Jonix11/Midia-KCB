//
//  MediaItemAPIConsumable.swift
//  Midia
//
//  Created by Jon Gonzalez on 28/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

protocol MediaItemAPIConsumable {
    
    func getLatesMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void)
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void)
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void)
}
