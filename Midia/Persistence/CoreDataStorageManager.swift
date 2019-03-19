//
//  CoreDataStorageManager.swift
//  Midia
//
//  Created by Jon Gonzalez on 12/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation
import CoreData

// TODO: Capa de abstracción para usar siempre media items

class CoreDataStorageManager: FavoritesProvidable {
    
    let mediaItemKind: MediaItemKind
    let stack = CoreDataStack.sharedInstance
    
    init(withMediaItemKind mediaItemKind: MediaItemKind) {
        self.mediaItemKind = mediaItemKind
    }
    
    func getFavorites() -> [MediaItemDetailedProvidable]? {
        // Creamos el contexto en el hilo principal
        let context = stack.persistentContainer.viewContext // Contexto de hilo principal
        
        // Creamos la solicitud de busqueda
        let fetchRequest: NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
        
        // Añadimos parámetros para ordenar el resultado de la solicitud
        let dateSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "publishedDate", ascending: true)
        let priceSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "price", ascending: false)
        fetchRequest.sortDescriptors = [dateSortDescriptor, priceSortDescriptor]
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites.map({ $0.mappedObject() })
        } catch {
            // assertionFailure nos va a petar a nosotros, pero en producción no va a petar
            assertionFailure("Error fetching media items")
            return nil
        }
        
    }
    
    func getFavorite(byId favoriteId: String) -> MediaItemDetailedProvidable? {
        
        let context = stack.persistentContainer.viewContext // Contexto de hilo principal
        let fetchRequest: NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "bookId = %@", favoriteId)
        fetchRequest.predicate = predicate
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites.last?.mappedObject()
        } catch {
            // assertionFailure nos va a petar a nosotros, pero en producción no va a petar
            assertionFailure("Error fetching media items by id \(favoriteId)")
            return nil
        }
    }
    
    func add(favorite: MediaItemDetailedProvidable) {
        
        let context = stack.persistentContainer.viewContext // Contexto de hilo principal
        if let book = favorite as? Book {
            let bookManaged = BookManaged(context: context)
            bookManaged.bookId = book.bookId
            bookManaged.bookTitle = book.title
            bookManaged.publishedDate = book.publishedDate
            bookManaged.coverURL = book.coverURL?.absoluteString
            if let rating = book.rating {
                bookManaged.rating = rating
            }
            if let numberOfReviews = book.numberOfReviews {
                bookManaged.numberOfReviews = Int32(numberOfReviews)
            }
            if let price = book.price {
                bookManaged.price = price
            }
            bookManaged.bookDescription = book.description
            
            book.authors?.forEach({ (authorName) in
                let author = Author(context: context)
                author.fullName = authorName
                bookManaged.addToAuthors(author)
            })
            do {
                try context.save()
            } catch {
                assertionFailure("Error saving context")
            }
            
        } else {
            fatalError("not supported yet :(")
        }
    }
    
    func remove(favoriteWithId favoriteId: String) {
        
        let context = stack.persistentContainer.viewContext // Contexto de hilo principal
        let fetchRequest: NSFetchRequest<BookManaged> = BookManaged.fetchRequest() // Creo la consulta
        let predicate: NSPredicate = NSPredicate(format: "bookId = %@", favoriteId)
        fetchRequest.predicate = predicate
        do {
            let favorites = try context.fetch(fetchRequest)
            favorites.forEach({ (bookManaged) in
                context.delete(bookManaged)
            })
            try context.save()
        } catch {
            assertionFailure("Error removing media item with id \(favoriteId)")
        }
    }
    
    
}
