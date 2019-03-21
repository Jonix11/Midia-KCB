//
//  ITunesMoviesAPIConsumerAlamofire.swift
//  Midia
//
//  Created by Jon Gonzalez on 21/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation
import Alamofire

class ITunesMoviesAPIConsumerAlamofire: MediaItemAPIConsumable {
    
    func getLatesMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        Alamofire.request(ITunesMoviesAPIConstant.getMoviesURL(withReleaseYear: "2018")).responseData { (response) in
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let movieCollection = try decoder.decode(MovieCollection.self, from: value)
                    success(movieCollection.results ?? [])
                } catch {
                    failure(error)
                }
            }
            
        }
    }
    
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        let paramsList = queryParams.components(separatedBy: " ")
        
        Alamofire.request(ITunesMoviesAPIConstant.getAbsoluteURL(withQueryParams: paramsList)).responseData { (response) in
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let movieCollection = try decoder.decode(MovieCollection.self, from: value)
                    success(movieCollection.results ?? [])
                } catch {
                    failure(error)
                }
            }
        }
    }
    
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(ITunesMoviesAPIConstant.urlForMovie(withId: mediaItemId)).responseData { (response) in
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let movieCollection = try decoder.decode(MovieCollection.self, from: value)
                    guard let movie = movieCollection.results?.first else {
                        return
                    }
                    success(movie)
                } catch {
                    failure(error)
                }
            }
        }
    }
    
}
