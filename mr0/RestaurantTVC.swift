//
//  RestaurantTVC.swift
//  mr0
//
//  Created by Ted Shaffer on 6/10/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import GooglePlaces


class RestaurantTVC: UITableViewController, SetVisitDateDelegate {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantTags: UILabel!
    @IBOutlet weak var visitDate: UILabel!
    
    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()
    var selectedDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantName.text = selectedPlace!.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let defaultVisitDate : Date = Date.init()
        let defaultVisitLbl = dateFormatter.string(from: defaultVisitDate)
        visitDate.text = defaultVisitLbl
    }
    
    
    func specifyVisitDate(visitDate: Date) {
        print("specifyVisitDate is \(visitDate)")
//        self.foodType = foodType
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant tvc prepare for segue invoked")
        
        if segue.identifier == "setVisitDateSegue" {
            let vc = segue.destination as! DatePickerViewController
            vc.setVisitDateDelegate = self
        }
    }
}
