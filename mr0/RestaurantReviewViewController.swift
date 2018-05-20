//
//  RestaurantReviewViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class RestaurantReviewViewController: UIViewController, SpecifyFoodTypeDelegate {

    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var visitDate: UIDatePicker!
    @IBOutlet weak var foodImage: UIImageView!
    
    var foodType: FoodType = .Other
    
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
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func specifyFoodType(foodType: FoodType) {
        print("specifyFoodType = is \(foodType)")
        self.foodType = foodType
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
            print("image received")
            self.foodImage.image = image
        }
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
    

    @IBAction func submit(_ sender: UIButton) {
        print("button pressed")
        print(restaurantName.text!)
        print(comments.text!)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: visitDate.date)
        print(selectedDate)
        
        // add restaurant information to the database
        let restaurantsDB = Database.database().reference().child("Restaurants")
        
        let restaurant : Restaurant = Restaurant()
        restaurant.name = restaurantName.text!
        restaurant.foodType = self.foodType
        restaurant.comments = comments.text!
        restaurant.dateVisited = visitDate.date
       
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(restaurant)
            print(String(data: data, encoding: .utf8)!)
            let dataAsString = String(data: data, encoding: .utf8)!
            print(dataAsString)
            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
                                        "RestaurantBody": dataAsString] as [String : Any]
            restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
                (error, reference) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    print("Restaurant saved successfully")
                }
            }
        }
        catch {
            print("encoder error")
        }
    }
    
    /*
    // MARK: - Navigation

    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant review prepare for segue invoked")
        
        if segue.identifier == "specifyFoodTypeSegue" {
            let vc = segue.destination as! FoodTypeTableViewController
            vc.specifyFoodTypeDelegate = self
        }
        else if (segue.identifier == "specifyLocationSegue") {
            print("segue to LocationTableViewController")
            if let nextViewController = segue.destination as? LocationTableViewController {
                nextViewController.likelyPlaces = likelyPlaces
            }

        }
        
    }
}


// Delegates to handle events for the location manager.
extension RestaurantReviewViewController: CLLocationManagerDelegate {
    
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
