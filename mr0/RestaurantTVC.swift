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
    @IBOutlet weak var visitDateLbl: UILabel!

    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()
    
    var visitDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantName.text = selectedPlace!.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        visitDate = Date.init()
        let dateVisitLbl = dateFormatter.string(from: visitDate!)
        visitDateLbl.text = dateVisitLbl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateVisitLbl = dateFormatter.string(from: visitDate!)
        visitDateLbl.text = dateVisitLbl
    }
    
    func specifyVisitDate(visitDate: Date) {
         self.visitDate = visitDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setVisitDateSegue" {
            let vc = segue.destination as! DatePickerViewController
            vc.setVisitDateDelegate = self
        }
    }
}
