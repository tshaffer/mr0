//
//  MenuItemViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 7/1/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class MenuItemViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var menuItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // FLIBBET
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        let rating = Float(Float(sender.value) / 10)
        menuItem?.rating = rating
        let ratingAsString = (String(format: "%.01f", rating))
        ratingLabel.text = "MenuItem rating: \(ratingAsString)"
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
