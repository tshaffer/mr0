//
//  ViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/5/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class MemoRappViewController: UITableViewController {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!

    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    // Update the map once the user has made their selection.
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        listLikelyPlaces()
    }
    
    override func viewDidLoad() {
        print ("MemoRappViewController viewDidLoad")
        super.viewDidLoad()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        listLikelyPlaces()
    }

    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    print("place: \(place)")
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare invoked")
        if (segue.identifier == "specifyFoodTypeSegue") {
            print("segue to FoodTypeTableViewController")
        }
        else if (segue.identifier == "specifyLocationSegue") {
            print("segue to LocationTableViewController")
        }
//        if segue.identifier == "Pizza"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
//        if segue.identifier == "Deep Dish"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
//        if segue.identifier == "Calzone"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
        
    }
}

// Delegates to handle events for the location manager.
extension MemoRappViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
}
