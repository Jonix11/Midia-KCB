//
//  MovieManaged+Mapping.swift
//  Midia
//
//  Created by Jon Gonzalez on 22/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

extension MovieManaged {
    
    func mappedObject() -> Movie {
        
        let directorsList = hasDirectors?.map({ (director) -> String in
            let director = director as! Director
            return director.fullName!
        })
        
        let url: URL? = movieCoverURL != nil ? URL(string: movieCoverURL!) : nil
        
        return Movie(movieId: movieId!, movieTitle: movieTitle!, movieDirectors: directorsList, movieReleaseDate: movieReleaseDate, movieDescription: movieDescription, movieCoverURL: url, movieRating: nil, movieNumbersOfReviews: nil, moviePrice: moviePrice)
    }
}
