//
//  MovieTests.swift
//  MidiaTests
//
//  Created by Jon Gonzalez on 20/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import XCTest
@testable import Midia

class MovieTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    let movieCoverURL = URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Video128/v4/23/b6/bc/23b6bc80-2e6b-1d79-d99f-44d8acdf18fd/source/100x100bb.jpg")
    
    var oneOfMyFavoriteMovies: Movie!

    override func setUp() {
        super.setUp()
        
        oneOfMyFavoriteMovies = Movie(movieId: "12345", movieTitle: "Los Vengadores, La Era de Ultron", movieDirectors: ["Joss Whedon"], movieReleaseDate: Date(timeIntervalSince1970: 1234567890), movieDescription: "Avengers vs Ultron", movieCoverURL: movieCoverURL, movieRating: 10.0, movieNumbersOfReviews: 1234, moviePrice: 9.99)
        
    }
    
    func testMovieExistence() {
        XCTAssertNotNil(oneOfMyFavoriteMovies)
    }
    
    func testDecodeMovieCollection() {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "movie-search-response", ofType: "json") else {
            XCTFail()
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let movieCollection = try decoder.decode(MovieCollection.self, from: data)
            XCTAssertNotNil(movieCollection)
            
            let firstMovie = movieCollection.results?.first
            XCTAssertNotNil(firstMovie?.movieId)
            XCTAssertNotNil(firstMovie?.movieTitle)
            XCTAssertNotNil(firstMovie?.movieDirectors)
            XCTAssertNotNil(firstMovie?.movieReleaseDate)
            XCTAssertNotNil(firstMovie?.movieDescription)
            XCTAssertNotNil(firstMovie?.movieCoverURL)
            XCTAssertNotNil(firstMovie?.moviePrice)
            
        } catch {
            XCTFail()
        }
    }
    
    func testEncodeMovie() {
        do {
            let movieData = try encoder.encode(oneOfMyFavoriteMovies)
            XCTAssertNotNil(movieData)
        } catch {
            XCTFail()
            
        }
    }
    
    func testEncodeDecodeMovie() {
        do {
            let movieData = try encoder.encode(oneOfMyFavoriteMovies)
            XCTAssertNotNil(movieData)
            
            let movie = try decoder.decode(Movie.self, from: movieData)
            XCTAssertNotNil(movie.movieId)
            XCTAssertNotNil(movie.movieTitle)
            XCTAssert(movie.movieDirectors!.count > 0)
            XCTAssertNotNil(movie.movieReleaseDate)
            XCTAssertNotNil(movie.movieDescription)
            XCTAssertNotNil(movie.movieCoverURL)
            XCTAssertNotNil(movie.moviePrice)
        } catch {
            XCTFail()
        }
    }

}
