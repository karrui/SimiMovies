//
//  MoviesDataModel.swift
//  SimiMovies
//
//  Created by Karrui Lau on 28/12/17.
//  Copyright © 2017 Karrui Lau. All rights reserved.
//

import UIKit

class MoviesDataModel {
    var moviesArray = [Movie]()
    var movieTitleArray = [String]()
    var moviesDictionary = [String: Movie]()
    var cinemasArray = [String]()
    
    
    func addTitlesToArray() {
        for movie in moviesArray {
            movieTitleArray.append(movie.title)
        }
    }
}

