//
//  Movie.swift
//  SimiMovies
//
//  Created by Karrui Lau on 28/12/17.
//  Copyright © 2017 Karrui Lau. All rights reserved.
//

import Foundation

class Movie {
    var id: Int
    var title: String
    var language: String
    var ageRating: String
    var duration: Int
    
    init(id: Int, title: String, language: String, ageRating: String, duration: Int) {
        self.id = id
        self.title = title
        self.language = language
        self.ageRating = ageRating
        self.duration = duration
    }
}
