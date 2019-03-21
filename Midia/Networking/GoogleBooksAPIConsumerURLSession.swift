//
//  GoogleBooksAPIConsumerURLSession.swift
//  Midia
//
//  Created by Jon Gonzalez on 04/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

class GoogleBooksAPIConsumerURLSession: MediaItemAPIConsumable {
    
    let session = URLSession.shared
    
    func getLatesMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        let url = GoogleBooksAPIConstant.getAbsoluteURL(withQueryParams: ["2019"])
        
        let task = session.dataTask(with: url) { (data, response, error) in
            // Si hay error, lo paso para arriba con la closure de failure
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let bookCollection = try decoder.decode(BookCollection.self, from: data)
                    DispatchQueue.main.async { success(bookCollection.items ?? []) } // si bookCollection.items es nil entonces envía una lista vacia
                } catch {
                    DispatchQueue.main.async { failure(error) } // Error parseando, lo enviamos para arriba
                }
            } else {
                DispatchQueue.main.async { success([]) }
            }
        }
        task.resume()
    }
    
    func getMediaItems(withQueryParams queryParams: String, success: @escaping ([MediaItemProvidable]) -> Void, failure: @escaping (Error?) -> Void) {
        
        let paramsList = queryParams.components(separatedBy: " ")
        
        let url = GoogleBooksAPIConstant.getAbsoluteURL(withQueryParams: paramsList)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            // Si hay error, lo paso para arriba con la closure de failure
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let bookCollection = try decoder.decode(BookCollection.self, from: data)
                    DispatchQueue.main.async { success(bookCollection.items ?? []) } // si bookCollection.items es nil entonces envía una lista vacia
                } catch {
                    DispatchQueue.main.async { failure(error) } // Error parseando, lo enviamos para arriba
                }
            } else {
                DispatchQueue.main.async { success([]) }
            }
        }
        task.resume()
    }
    
    func getMediaItem(byId mediaItemId: String, success: @escaping (MediaItemDetailedProvidable) -> Void, failure: @escaping (Error?) -> Void) {
        
        let url = GoogleBooksAPIConstant.urlForBook(withId: mediaItemId)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            // Si hay error, lo paso para arriba con la closure de failure
            if let error = error {
                DispatchQueue.main.async { failure(error) }
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let book = try decoder.decode(Book.self, from: data)
                    DispatchQueue.main.async { success(book) } // si bookCollection.items es nil entonces envía una lista vacia
                } catch {
                    DispatchQueue.main.async { failure(error) } // Error parseando, lo enviamos para arriba
                }
            }
//            else {
//                DispatchQueue.main.async { success([]) }
//            }
        }
        task.resume()
        
    }
    
}
