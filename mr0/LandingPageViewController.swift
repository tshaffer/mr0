//
//  LandingPageViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/3/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class LandingPageViewController: UIViewController, GMSMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var landingPageMapView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    let defaultLocation = CLLocation(latitude: 37.397686, longitude: -122.061104)
    
    var searchText: String = ""
    
    var restaurants = [Restaurant]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        landingPageMapView.addSubview(mapView)
        
        mapView.isHidden = false
        
        // load restaurants from firebase
        let restaurantsDB = Database.database().reference().child("Restaurants")
        restaurantsDB.observe(.childAdded, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                _ = getData["Sender"] as? String
                let restaurantBodyJSON = getData["RestaurantBody"] as? String
                let jsonData = restaurantBodyJSON?.data(using: .utf8)
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
                let restaurantDictionary = dictionary as! Dictionary<String, AnyObject>
                
                let name = restaurantDictionary["name"]
                let foodType = restaurantDictionary["foodType"]
                let comments = restaurantDictionary["comments"]
                _ = restaurantDictionary["dateVisited"]
                
                let location = restaurantDictionary["location"]
                let locationDictionary = location as! Dictionary<String, Double>
                let latitude = locationDictionary["latitude"]
                let longitude = locationDictionary["longitude"]
                
                var restaurant : Restaurant = Restaurant()
                restaurant.name = name as! String
                restaurant.foodType = FoodType(rawValue: (foodType as! Int))!
                restaurant.location = Location(latitude: latitude!, longitude: longitude!)
                restaurant.comments = comments as! String
                //                restaurant.dateVisited = dateVisited as! Date
                self.restaurants.append(restaurant)
                
                var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
                coordinates.latitude = restaurant.location.latitude;
                coordinates.longitude = restaurant.location.longitude;

                let marker = GMSMarker(position: (coordinates))
                marker.title = restaurant.name
                marker.snippet = restaurant.comments
                marker.map = self.mapView
            }
            
            self.landingPageMapView.bringSubview(toFront: self.searchBar)
        })
    }

    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You didTapPOIWithPlaceID \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt location: CLLocationCoordinate2D) {
        print("You didTapAt \(location.latitude)/\(location.longitude)")
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt location: CLLocationCoordinate2D) {
        print("You didLongPressAt \(location.latitude)/\(location.longitude)")
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Marker tapped")
        print ("marker is: \(marker)")
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("You didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("You didTap")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar: \(searchText)")
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBar search clicked: \(self.searchText)")
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
