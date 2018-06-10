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


class RestaurantTVC: UITableViewController {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantTags: UILabel!
    
    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()
    var selectedDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantName.text = selectedPlace!.name
    }
    
}
