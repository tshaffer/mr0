//
//  RestaurantReviewViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class RestaurantReviewViewController: UIViewController {

    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var visitDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        print("button pressed")
        print(restaurantName.text!)
        print(comments.text!)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: visitDate.date)
        print(selectedDate)
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
