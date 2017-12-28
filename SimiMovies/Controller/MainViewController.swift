//
//  ViewController.swift
//  SimiMovies
//
//  Created by Karrui Lau on 27/12/17.
//  Copyright © 2017 Karrui Lau. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyPickerPopover

// Global variable
var moviesDataModel = MoviesDataModel()
var showtimesDataModel = ShowtimeDataModel()

class ViewController: UIViewController {
    
    // Constants
    let MOVIE_INFO_URL = "https://karrui.github.io/movieinfo"
    let CINEMA_INFO_URL = "https://karrui.github.io/cinemas"
    let SHOWTIME_INFO_URL = "https://karrui.github.io/showtimes"
    
    // Instance variables
    var selectedMovieTitle: String = ""
    var selectedCinemaTitle: String = ""
    
    @IBOutlet weak var moviePicker: UIButton!
    @IBOutlet weak var cinemaPicker: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getMoviesInfo(url: MOVIE_INFO_URL)
        getCinemasInfo(url: CINEMA_INFO_URL)
        getShowtimesInfo(url: SHOWTIME_INFO_URL)
        goButton.isEnabled = false
        goButton.setTitleColor(UIColor.gray, for: .disabled)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func moviePickerPressed(_ sender: Any) {
        let p = StringPickerPopover(title: "Choose a movie!", choices: moviesDataModel.movieTitleArray)
            .setDoneButton(
                action: {  popover, selectedRow, selectedString in
                    self.moviePicker.setTitle(selectedString, for: .normal)
                    self.selectedMovieTitle = selectedString
                    self.goButton.isEnabled = true
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: moviePicker, baseViewController: self)
    }
    
    @IBAction func cinemaPickerPressed(_ sender: Any) {
        let p = StringPickerPopover(title: "Choose a cinema!", choices: moviesDataModel.cinemasArray)
            .setDoneButton(
                action: {  popover, selectedRow, selectedString in
                    self.cinemaPicker.setTitle(selectedString, for: .normal)
                    self.selectedCinemaTitle = selectedString
                    self.goButton.isEnabled = true
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: moviePicker, baseViewController: self)
    }

    
    func getMoviesInfo(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Retrieved moviesInfo response")
                let moviesInfoJSON: JSON = JSON(response.result.value!)
                self.updateMoviesData(json: moviesInfoJSON)
            } else {
                print("Connection issues")
            }
        }
    }
    
    func getCinemasInfo(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Retrieved cinemasInfo response")
                let cinemasInfoJSON: JSON = JSON(response.result.value!)
                self.updateCinemasData(json: cinemasInfoJSON)
            } else {
                print("Connection issues")
            }
        }
    }
    
    func getShowtimesInfo(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Retrieved showtimesInfo response")
                let showtimesInfoJSON: JSON = JSON(response.result.value!)
                self.updateShowtimesData(json: showtimesInfoJSON)
            } else {
                print("Connection issues")
            }
        }
    }
    
    func updateShowtimesData(json: JSON) {
        var i: Int = 0
        
        while true {
            var showtimeJSON = json[i]
            if showtimeJSON != JSON.null {
                let cinemaID = showtimeJSON["cinema_id"].intValue
                let movieID = showtimeJSON["movie_id"].intValue
                let datetime = showtimeJSON["datetime"].stringValue
                showtimesDataModel.iCinemaJMovie[cinemaID][movieID].append(datetime)
                showtimesDataModel.iMovieJCinema[movieID][cinemaID].append(datetime)
                i += 1
            } else {
                break
            }
        }
        
        for element in showtimesDataModel.iCinemaJMovie {
            print(element)
        }
    }
    
    func updateCinemasData(json: JSON) {
        var i: Int = 0
        
        while true {
            var cinemaJSON = json[i]
            if cinemaJSON != JSON.null {
                moviesDataModel.cinemasArray.append(cinemaJSON["name"].stringValue)
                i += 1
            } else {
                break
            }
        }
    }
    
    func updateMoviesData(json: JSON) {
        var i: Int = 0
        
        while true {
            var movieJSON = json[i]
            if movieJSON != JSON.null {
                let movieTitle = movieJSON["title"].stringValue
                let movie = Movie(id: movieJSON["id"].intValue, title: movieTitle, language: movieJSON["language"].stringValue, ageRating: movieJSON["ageRating"].stringValue, duration: movieJSON["duration"].intValue)
                moviesDataModel.moviesArray.append(movie)
                moviesDataModel.moviesDictionary[movieTitle] = movie
                i += 1
            } else {
                break
            }
        }
        moviesDataModel.addTitlesToArray()
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
    
    }
}

