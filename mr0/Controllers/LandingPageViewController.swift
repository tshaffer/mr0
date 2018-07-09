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
import GooglePlaces

protocol ControllerDelegate {
    func updateRestaurant(restaurant: Restaurant)
}

class LandingPageViewController: UIViewController, DBInterfaceDelegate, GMSMapViewDelegate, UISearchBarDelegate, ControllerDelegate {
    
    @IBOutlet weak var landingPageMapView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var resultsLabel1: UILabel!
    @IBOutlet weak var resultsLabel2: UILabel!
    
    var markersByRestaurant: [String: GMSMarker] = [:]

    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    let defaultLocation = CLLocation(latitude: 37.397686, longitude: -122.061104)
    
    var placesClient: GMSPlacesClient!
    
    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()
    var selectedRestaurant: Restaurant?

    var searchText: String = ""
    
    var restaurants = [Restaurant]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBInterface.dbInterfaceDelegate = self
        searchBar.delegate = self
        
        placesClient = GMSPlacesClient.shared()

        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        landingPageMapView.addSubview(mapView)
        
        mapView.isHidden = false
                
        // load database
        DBInterface.loadDB()
        
        self.landingPageMapView.bringSubview(toFront: self.searchBar)
    }

    func dbLoaded() {
        
        // retrieve restaurants
        restaurants = DBInterface.getRestaurants()
        
        for restaurant in restaurants {
            
            var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
            coordinates.latitude = restaurant.location.latitude;
            coordinates.longitude = restaurant.location.longitude;
            
            let marker = GMSMarker(position: (coordinates))
            marker.title = restaurant.name
            marker.snippet = restaurant.comments
            marker.map = self.mapView
            marker.userData = restaurant
            
            markersByRestaurant[restaurant.dbId] = marker
        }
    }

    func updateRestaurant(restaurant: Restaurant) {
        
        let marker = markersByRestaurant[restaurant.dbId]
        marker?.userData = restaurant
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You didTapPOIWithPlaceID \(name): \(placeID), \(location.latitude)/\(location.longitude)")
        
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            self.selectedPlace = place
            self.selectedLocation = location
            
            self.resultsLabel1.text = place.name
            self.resultsLabel2.text = place.formattedAddress!

            self.selectedRestaurant = nil
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt location: CLLocationCoordinate2D) {
        print("You didTapAt \(location.latitude)/\(location.longitude)")
    }

    func mapView(_ mapView: GMSMapView, didLongPressAt location: CLLocationCoordinate2D) {
        print("You didLongPressAt \(location.latitude)/\(location.longitude)")
        selectedLocation = location
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let restaurant = (marker.userData as! Restaurant)
        let location = restaurant.location
        self.selectedLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.resultsLabel1.text = restaurant.name
        self.resultsLabel2.text = ""
        self.selectedRestaurant = restaurant

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
        
    @IBAction func addButtonPressed(_ sender: Any) {
        
        if selectedRestaurant != nil {
            performSegue(withIdentifier: "addRestaurantSegue", sender: self)
        }
        else if selectedPlace != nil {
            
            selectedRestaurant = Restaurant()
            selectedRestaurant?.name = selectedPlace!.name
            selectedRestaurant?.location = Location(
                latitude: selectedLocation.latitude,
                longitude: selectedLocation.longitude)
            
            performSegue(withIdentifier: "addRestaurantSegue", sender: self)
        }
        else
        {
            print("selected place nil")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("restaurant review prepare for segue invoked")

        if (segue.identifier == "addRestaurantSegue") {
            if let restaurantVC = segue.destination as? RestaurantVC {
                restaurantVC.controllerDelegate = self
                restaurantVC.selectedRestaurant = selectedRestaurant
            }
        }
    }
    
    @IBAction func unwindToLandingPage(unwindSegue: UIStoryboardSegue) {
        print("unwindToLandingPage")
    }

}
