//
//  Constants.swift
//  Midia
//
//  Created by Jon Gonzalez on 04/03/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

struct GoogleBooksAPIConstant {
    
    static private func getApiKey() -> String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("")
        }
        let infoPlistDict = NSDictionary(contentsOfFile: path)
        
        let apiKey = infoPlistDict?.object(forKey: "GoogleAPIAccessKey") as! String
        
        return apiKey
        
    }
    
    static func getAbsoluteURL(withQueryParams queryParams: [String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/books/v1/volumes"
        components.queryItems = [URLQueryItem(name: "key", value: getApiKey())]
        components.queryItems?.append(URLQueryItem(name: "q", value: queryParams.joined(separator: "+")))
        
        return components.url!
    }
    
    static func urlForBook(withId bookId: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/books/v1/volumes/\(bookId)"
        components.queryItems = [URLQueryItem(name: "key", value: getApiKey())]
        return components.url!
    }
}
