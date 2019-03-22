//
//  MediaItemProvider.swift
//  Midia
//
//  Created by Jon Gonzalez on 28/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

class MediaItemProvider {
    
    let mediaItemKind: MediaItemKind
    let apiConsumer: MediaItemAPIConsumable

    
    init(withMediaItemKind mediaItemKind: MediaItemKind, apiConsumer: MediaItemAPIConsumable) {
        self.mediaItemKind = mediaItemKind
        self.apiConsumer = apiConsumer
    }
    
    convenience init(withMediaItemKind mediaItemKind: MediaItemKind) {
        switch mediaItemKind {
        case .book:
            self.init(withMediaItemKind: mediaItemKind, apiConsumer: GoogleBooksAPIConsumerURLSession())
        case .movie:
            self.init(withMediaItemKind: mediaItemKind, apiConsumer: ITunesMoviesAPIConsumerAlamofire())
        case .game:
            fatalError("MediaItemKind not supported yet :( Coming soon")
        }
    }
    
    func getHomeMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        // guardar en cache
        apiConsumer.getLatesMediaItems(onSuccess: { (mediaItems) in
            // comprobar que estamos hilo principal
            assert(Thread.current == Thread.main)
            success(mediaItems)
        }, failure: { (error) in
            // comprobar que estamos hilo principal
            assert(Thread.current == Thread.main)
            failure(error)
        })
    }
    
    func getSearchMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        apiConsumer.getMediaItems(withQueryParams: queryParams, success: { (mediaItems) in
            assert(Thread.current == Thread.main)
            success(mediaItems)
        }, failure: { (error) in
            assert(Thread.current == Thread.main)
            failure(error)
        })
    }
    
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void) {
        apiConsumer.getMediaItem(byId: mediaItemId, success: { (mediaItem) in
            assert(Thread.current == Thread.main)
            success(mediaItem)
        }) { (error) in
            assert(Thread.current == Thread.main)
            failure(error)
        }
    }
    
}


