//
//  Movie.swift
//  Midia
//
//  Created by Jon Gonzalez on 20/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

struct Movie {
    let movieId: String
    let movieTitle: String
    let movieDirectors: [String]?
    let movieReleaseDate: Date?
    let movieDescription: String?
    let movieCoverURL: URL?
    let movieRating: Float?
    let movieNumbersOfReviews: Int?
    let moviePrice: Float?
    
    init (movieId: String, movieTitle: String, movieDirectors: [String]? = nil, movieReleaseDate: Date? = nil, movieDescription: String? = nil, movieCoverURL: URL? = nil, movieRating: Float? = nil, movieNumbersOfReviews: Int? = nil, moviePrice: Float? = nil) {
        self.movieId = movieId
        self.movieTitle = movieTitle
        self.movieDirectors = movieDirectors
        self.movieReleaseDate = movieReleaseDate
        self.movieDescription = movieDescription
        self.movieCoverURL = movieCoverURL
        self.movieRating = movieRating
        self.movieNumbersOfReviews = movieNumbersOfReviews
        self.moviePrice = moviePrice
    }
    
}

extension Movie: Codable {
    
    enum CodingKeys: String, CodingKey {
        case movieId = "trackId"
        case movieTitle = "trackName"
        case movieDirectors = "artistName"
        case movieReleaseDate = "releaseDate"
        case movieDescription = "longDescription"
        case movieCoverURL = "artworkUrl100"
        case moviePrice = "trackPrice"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodeId = try container.decode(Int.self, forKey: .movieId)
        movieId = String(decodeId)
        
        movieTitle = try container.decode(String.self, forKey: .movieTitle)
        
        if let movieDirectorsString = try container.decodeIfPresent(String.self, forKey: .movieDirectors) {
            movieDirectors = movieDirectorsString.components(separatedBy: " & ")
        } else {
            movieDirectors = nil
        }

        if let movieReleaseDateString = try container.decodeIfPresent(String.self, forKey: .movieReleaseDate) {
            movieReleaseDate = DateFormatter.moviesAPIDateFormatter.date(from: movieReleaseDateString)
        } else {
            movieReleaseDate = nil
        }

        movieDescription = try container.decodeIfPresent(String.self, forKey: .movieDescription)

        movieCoverURL = try container.decodeIfPresent(URL.self, forKey: .movieCoverURL)

        movieRating = nil
        movieNumbersOfReviews = nil

        moviePrice = try container.decodeIfPresent(Float.self, forKey: .moviePrice)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let movieIdInt = Int(movieId) {
            try container.encode(movieIdInt, forKey: .movieId)
        }
        
        try container.encode(movieTitle, forKey: .movieTitle)
        
        try container.encodeIfPresent(movieDirectors?.joined(separator: " & "), forKey: .movieDirectors)
        if let date = movieReleaseDate {
            try container.encode(DateFormatter.moviesAPIDateFormatter.string(from: date), forKey: .movieReleaseDate)
        }
        try container.encodeIfPresent(movieDescription, forKey: .movieDescription)
        try container.encodeIfPresent(movieCoverURL, forKey: .movieCoverURL)
        try container.encodeIfPresent(moviePrice, forKey: .moviePrice)
    }
}

extension Movie: MediaItemProvidable {
    
    var mediaItemId: String {
        return movieId
    }
    
    var title: String {
        return movieTitle
    }
    
    var imageURL: URL? {
        return movieCoverURL
    }
    
}

extension Movie: MediaItemDetailedProvidable {
    var creatorsName: String? {
        return movieDirectors?.joined(separator: ", ")
    }
    
    var rating: Float? {
        return movieRating
    }
    
    var numberOfReviews: Int? {
        return movieNumbersOfReviews
    }
    
    var creationDate: Date? {
        return movieReleaseDate
    }
    
    var price: Float? {
        return moviePrice
    }
    
    var description: String? {
        return movieDescription
    }
    
}
