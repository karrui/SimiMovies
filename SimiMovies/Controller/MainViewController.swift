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
var showtimeDataModel = ShowtimeDataModel()

class ViewController: UIViewController {
    
    // Constants
    let MOVIE_INFO_URL = "https://karrui.github.io/movieinfo"
    let CINEMA_INFO_URL = "https://karrui.github.io/cinemas"
    let SHOWTIME_INFO_URL = "https://karrui.github.io/showtimes"
    
    // Instance variables
    var selectedMovieTitle: String = ""
    var selectedCinemaTitle: String = ""
    var selectedMovieID: Int = 0
    var selectedCinemaID: Int = 0
    
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
    
    func preparePickerArray(originalArray: [String]) -> [String] {
        var newArray = ["Select one if you want"] + originalArray
        while newArray.contains("") {
            if let itemToRemoveIndex = newArray.index(of: "") {
                newArray.remove(at: itemToRemoveIndex)
            }
        }
        
        return newArray
    }
    
    @IBAction func moviePickerPressed(_ sender: Any) {
        let p = StringPickerPopover(title: "Choose a movie!", choices: preparePickerArray(originalArray: moviesDataModel.movieTitleArray))
            .setDoneButton(
                action: {  popover, selectedRow, selectedString in
                    self.moviePicker.setTitle(selectedString, for: .normal)
                    self.selectedMovieTitle = selectedString
                    self.selectedMovieID = selectedRow
                    if self.selectedCinemaID != 0 || self.selectedMovieID != 0 {
                        self.goButton.isEnabled = true
                    } else {
                        self.goButton.isEnabled = false
                    }
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: moviePicker, baseViewController: self)
    }
    
    @IBAction func cinemaPickerPressed(_ sender: Any) {
        let p = StringPickerPopover(title: "Choose a cinema!", choices: preparePickerArray(originalArray: moviesDataModel.cinemasArray))
            .setDoneButton(
                action: {  popover, selectedRow, selectedString in
                    self.cinemaPicker.setTitle(selectedString, for: .normal)
                    self.selectedCinemaTitle = selectedString
                    self.selectedCinemaID = selectedRow
                    if self.selectedCinemaID != 0 || self.selectedMovieID != 0 {
                        self.goButton.isEnabled = true
                    } else {
                        self.goButton.isEnabled = false
                    }
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
                
                let convertedDate = convertISODate(isoDate: datetime)
                let convertedTime = convertISOTime(isoDate: datetime)
                
                let showtime = Showtime(movieTime: convertedTime, movieDate: convertedDate, movieID: movieID, cinemaID: cinemaID)
                
                showtimeDataModel.allShowTimes.append(showtime)
                
                i += 1
            } else {
                break
            }
        }
    }
    
    func convertISODate(isoDate: String) -> String {
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = isoDateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        let finalDate = calendar.date(from:components)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM"
        return dateFormatter.string(from: finalDate!)
    }
    
    func convertISOTime(isoDate: String) -> String {
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = isoDateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let finalDate = calendar.date(from:components)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: finalDate!)
    }
    
    func updateCinemasData(json: JSON) {
        var i: Int = 0
        
        while true {
            var cinemaJSON = json[i]
            if cinemaJSON != JSON.null {
                let cinemaName = cinemaJSON["name"].stringValue
                moviesDataModel.cinemasArray.append(cinemaName)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResultsScreen" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.cinemaIDPassedOver = selectedCinemaID
            destinationVC.cinemaTitlePassedOver = selectedCinemaTitle
            destinationVC.movieIDPassedOver = selectedMovieID
            destinationVC.movieTitlePassedOver = selectedMovieTitle
            
            // a movie is selected but no cinema selected
            if selectedMovieID != 0 && selectedCinemaID == 0 {
                var newArray = [Showtime]()
                for element in showtimeDataModel.allShowTimes {
                    if element.movieID == selectedMovieID {
                        newArray.append(element)
                    }
                }
                destinationVC.arraySizePassedOver = newArray.count
                destinationVC.resultsArray = newArray
                destinationVC.typeSentOver = "10"
            }
            // no movie selected, cinema selected
            else if selectedMovieID == 0 && selectedCinemaID != 0 {
                var newArray = [Showtime]()
                for element in showtimeDataModel.allShowTimes {
                    if element.cinemaID == selectedCinemaID {
                        newArray.append(element)
                    }
                }
                destinationVC.arraySizePassedOver = newArray.count
                destinationVC.resultsArray = newArray
                destinationVC.typeSentOver = "01"
            }
            // both selected
            else {
                var newArray = [Showtime]()
                for element in showtimeDataModel.allShowTimes {
                    if element.cinemaID == selectedCinemaID && element.movieID == selectedMovieID {
                        newArray.append(element)
                    }
                }
                destinationVC.arraySizePassedOver = newArray.count
                destinationVC.resultsArray = newArray
                destinationVC.typeSentOver = "11"
            }
        }
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
    
    }
}

