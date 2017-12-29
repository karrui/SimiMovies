//
//  ResultsViewController.swift
//  SimiMovies
//
//  Created by Karrui Lau on 28/12/17.
//  Copyright © 2017 Karrui Lau. All rights reserved.
//

import UIKit
import LBTAComponents

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var resultsArray = [Showtime]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySizePassedOver!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath)
        
        switch typeSentOver {
        case "10"?:
            cell.textLabel?.text = "" + resultsArray[indexPath.row].movieTime + "@" + resultsArray[indexPath.row].cinemaName
            break
        case "01"?:
            cell.textLabel?.text = "" + resultsArray[indexPath.row].movieName + "@" + resultsArray[indexPath.row].movieTime
            break
        default:    // case "11"
            cell.textLabel?.text = "" + resultsArray[indexPath.row].movieTime
        }
        return cell
    }
    
    
    // Instance variables
    var movieIDPassedOver: Int?
    var cinemaIDPassedOver: Int?
    
    var cinemaTitlePassedOver: String?
    var movieTitlePassedOver: String?
    
    var arraySizePassedOver: Int?
    
    /* What type sent over
     "10" for movieID sent, cinemaID not sent
     "01" for movieID not sent, cinemaID sent
     "11" for both movieID and cinemaID sent
     */
    var typeSentOver: String?
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        if movieIDPassedOver == 0 {
            self.resultsLabel.text = "Movies at \(cinemaTitlePassedOver ?? "No Cinema")"
        } else if cinemaIDPassedOver == 0 {
            self.resultsLabel.text = "\(movieTitlePassedOver ?? "No title") results"
        } else {
            self.resultsLabel.text = "\(movieTitlePassedOver ?? "No Movie") at \(cinemaTitlePassedOver ?? "No Cinema")"
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
