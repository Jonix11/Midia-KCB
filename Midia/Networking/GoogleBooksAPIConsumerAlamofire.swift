//
//  GoogleBooksAPIConsumerAlamofire.swift
//  Midia
//
//  Created by Jon Gonzalez on 04/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation
import Alamofire

class GoogleBooksAPIConsumerAlamofire: MediaItemAPIConsumable {
    
    
    
    func getLatesMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        Alamofire.request(GoogleBooksAPIConstant.getAbsoluteURL(withQueryParams: ["2010"])).responseData { (response) in
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let bookCollection = try decoder.decode(BookCollection.self, from: value)
                    success(bookCollection.items ?? []) // si bookCollection.items es nil entonces envía una lista vacia
                } catch {
                    failure(error) // Error parseando, lo enviamos para arriba
                }
            }
        }
    }
    
    
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        let paramsList = queryParams.components(separatedBy: " ")
        
        Alamofire.request(GoogleBooksAPIConstant.getAbsoluteURL(withQueryParams: paramsList)).responseData { (response) in
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let bookCollection = try decoder.decode(BookCollection.self, from: value)
                    success(bookCollection.items ?? []) // si bookCollection.items es nil entonces envía una lista vacia
                } catch {
                    failure(error) // Error parseando, lo enviamos para arriba
                }
            }
        }
    }
    
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void) {
        
        Alamofire.request(GoogleBooksAPIConstant.urlForBook(withId: mediaItemId)).responseData { (response) in
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    let book = try decoder.decode(Book.self, from: value)
                    success(book)
                } catch {
                    failure(error) // Error parseando, lo enviamos para arriba
                }
            }
        }
    }
    
    
}
