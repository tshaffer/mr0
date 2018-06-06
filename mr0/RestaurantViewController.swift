//
//  RestaurantViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/5/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import GooglePlaces

class RestaurantViewController: UIViewController, SpecifyFoodTypeDelegate {

    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var visitDateBtn: UIButton!
    
    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()

    var foodType: FoodType = .Other

    var visitDate : Date = Date.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantName.text = selectedPlace!.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: visitDate)
        visitDateBtn.setTitle(selectedDate,for: .normal)

        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func setFoodTypes(_ sender: Any) {
    }
    
    @IBAction func setVisitDate(_ sender: Any) {
    }
    
    func specifyFoodType(foodType: FoodType) {
        print("specifyFoodType is \(foodType)")
        self.foodType = foodType
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant review prepare for segue invoked")
        
        if segue.identifier == "specifyFoodTypeSegue" {
            let vc = segue.destination as! FoodTypeTableViewController
            vc.specifyFoodTypeDelegate = self
        }
        
        
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
