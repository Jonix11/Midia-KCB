//
//  DateFormatter+Custom.swift
//  Midia
//
//  Created by Jon Gonzalez on 26/02/2019.
//  Copyright © 2019 Jon Gonzalez. All rights reserved.
//

import Foundation

extension DateFormatter {
    // Aquí se le pasa una closure. Los paréntesis que están después de la closure es para que se ejecuta. Al fin y al cabo
    // a la variable estática booksAPIDateFormatter se le asigna una closure, es decir, una función
    static let booksAPIDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
