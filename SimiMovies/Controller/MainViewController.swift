//
//  ViewController.swift
//  SimiMovies
//
//  Created by Karrui Lau on 27/12/17.
//  Copyright © 2017 Karrui Lau. All rights reserved.
//

import UIKit
import McPicker

class ViewController: UIViewController {
    
    let data: [[String]] = [
        ["Today", "Tomorrow", "Day after"]
    ]
    
    var datePicked = Date()
    
    @IBOutlet weak var datePicker: UIButton!
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

    @IBAction func datePickerPressed(_ sender: UIButton) {
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let mcPicker = McPicker(data: data)
        mcPicker.setToolbarItems(items: [flexibleSpace])
        McPicker.showAsPopover(data:data, fromViewController: self, sourceView: sender, cancelHandler: { () -> Void in
            
            print("Canceled Popover")
            
        }, doneHandler: { (selections: [Int : String]) -> Void in
            
            print("Done with Popover")
            if let name = selections[0] {
                self.datePicker.setTitle(name, for: .normal)
                
                if name == "Today" {
                    self.datePicked = Date()
                } else if name == "Tomorrow" {
                    self.datePicked = Date(timeIntervalSinceNow: 86400)
                } else {
                    self.datePicked = Date(timeIntervalSinceNow: 172800)
                }
            }
        })
        
        print(datePicked)
    }
    
}

