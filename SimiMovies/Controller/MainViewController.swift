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

class ViewController: UIViewController {
    
    // Constants
    let MOVIE_INFO_URL = "https://karrui.github.io/movieinfo"
    
    // Instance variables
    var selectedMovieID: Int = 0
    
    @IBOutlet weak var moviePicker: UIButton!
    @IBOutlet weak var cinemaPicker: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getMoviesInfo(url: MOVIE_INFO_URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func moviePickerPressed(_ sender: Any) {
        showPopupMoviePicker()
    }
    
    func showPopupMoviePicker() {
        let p = StringPickerPopover(title: "Choose a movie", choices: moviesDataModel.movieTitleArray)
            .setDoneButton(
                action: {  popover, selectedRow, selectedString in
                    print("done row \(selectedRow) \(selectedString)")
                    self.moviePicker.setTitle(selectedString, for: .normal)
                    self.selectedMovieID = moviesDataModel.moviesDictionary[selectedString]!.id
                    print(self.selectedMovieID)
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: moviePicker, baseViewController: self)
    }
    
    func getMoviesInfo(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Retrieved response")
                let moviesInfoJSON: JSON = JSON(response.result.value!)
                self.updateMoviesData(json: moviesInfoJSON)
            } else {
                print("Connection issues")
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
    
}

