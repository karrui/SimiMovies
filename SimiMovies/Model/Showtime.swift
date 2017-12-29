//
//  Showtime.swift
//  SimiMovies
//
//  Created by Karrui Lau on 28/12/17.
//  Copyright © 2017 Karrui Lau. All rights reserved.
//

import Foundation
import SwiftDate

class Showtime {
    var movieTime: String = ""
    var movieDate: String = ""
    var movieID: Int = 0
    var cinemaID: Int = 0
    var cinemaName: String = ""
    var movieName: String = ""
    
    init(movieTime: String, movieDate: String, movieID: Int, cinemaID: Int) {
        self.movieTime = movieTime
        self.movieDate = movieDate
        self.movieID = movieID
        self.cinemaID = cinemaID
        self.cinemaName = moviesDataModel.cinemasArray[cinemaID - 1]
        self.movieName = moviesDataModel.moviesArray[movieID - 1].title
    }
}
