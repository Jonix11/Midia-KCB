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
        switch mediaItemKind {
        case .book:
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
        case .movie:
            let context = stack.persistentContainer.viewContext // Contexto de hilo principal
            
            let fetchRequest: NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let dateSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "movieReleaseDate", ascending: true)
            let priceSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "moviePrice", ascending: false)
            fetchRequest.sortDescriptors = [dateSortDescriptor, priceSortDescriptor]
            
            do {
                let favorites = try context.fetch(fetchRequest)
                return favorites.map({ $0.mappedObject() })
            } catch {
                assertionFailure("Error fetching media items")
                return nil
            }
        default:
            assertionFailure("Media Kind not support yet")
            return nil
        }
        
        
    }
    
    func getFavorite(byId favoriteId: String) -> MediaItemDetailedProvidable? {
        switch mediaItemKind {
        case .book:
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
        case .movie:
            let context = stack.persistentContainer.viewContext // Contexto de hilo principal
            let fetchRequest: NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let predicate: NSPredicate = NSPredicate(format: "movieId = %@", favoriteId)
            fetchRequest.predicate = predicate
            
            do {
                let favorites = try context.fetch(fetchRequest)
                return favorites.last?.mappedObject()
            } catch {
                // assertionFailure nos va a petar a nosotros, pero en producción no va a petar
                assertionFailure("Error fetching media items by id \(favoriteId)")
                return nil
            }
        default:
            assertionFailure("Media Kind not support yet")
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
            
        } else {
            if let movie = favorite as? Movie {
                let movieManaged = MovieManaged(context: context)
                movieManaged.movieId = movie.movieId
                movieManaged.movieTitle = movie.movieTitle
                movieManaged.movieReleaseDate = movie.movieReleaseDate
                movieManaged.movieDescription = movie.movieDescription
                movieManaged.movieCoverURL = movie.movieCoverURL?.absoluteString
                if let price = movie.moviePrice {
                    movieManaged.moviePrice = price
                }
                
                movie.movieDirectors?.forEach({ (directorName) in
                    let director = Director(context: context)
                    director.fullName = directorName
                    movieManaged.addToHasDirectors(director)
                })
            } else {
                fatalError("not supported yet :(")
            }
        }
        do {
            try context.save()
        } catch {
            assertionFailure("Error saving context")
        }
    }
    
    func remove(favoriteWithId favoriteId: String) {
        switch mediaItemKind {
        case .book:
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
        case .movie:
            let context = stack.persistentContainer.viewContext // Contexto de hilo principal
            let fetchRequest: NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest() // Creo la consulta
            let predicate: NSPredicate = NSPredicate(format: "movieId = %@", favoriteId)
            fetchRequest.predicate = predicate
            do {
                let favorites = try context.fetch(fetchRequest)
                favorites.forEach({ (movieManaged) in
                    context.delete(movieManaged)
                })
                try context.save()
            } catch {
                assertionFailure("Error removing media item with id \(favoriteId)")
            }
        default:
            assertionFailure("Media Kind not support yet")
        }
        
    }
    
    
}
