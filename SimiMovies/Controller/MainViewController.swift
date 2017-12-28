//
//  ViewController.swift
//  SimiMovies
//
//  Created by Karrui Lau on 27/12/17.
//  Copyright © 2017 Karrui Lau. All rights reserved.
//

import UIKit
import McPicker
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    // Constants
    let MOVIE_INFO_URL = "https://karrui.github.io/movieinfo"
    
    // Instance variables
    var moviesDataModel = MoviesDataModel()
    
    @IBOutlet weak var moviePicker: UIButton!
    @IBOutlet weak var cinemaPicker: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func moviePickerPressed(_ sender: Any) {
        getMoviesInfo(url: MOVIE_INFO_URL)
        showPopupMoviePicker()
    }
    
    func showPopupMoviePicker() {
        
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
                if movieTitle.isEmpty { // ignore cases where scraper gets empty strings
                    continue
                }
                let movie = Movie(id: movieJSON["id"].intValue, title: movieTitle, language: movieJSON["language"].stringValue, ageRating: movieJSON["ageRating"].stringValue, duration: movieJSON["duration"].intValue)
                moviesDataModel.moviesArray.append(movie)
                i += 1
                
                print(movie.title)
            } else {
                break
            }
        }
    }
    
}

