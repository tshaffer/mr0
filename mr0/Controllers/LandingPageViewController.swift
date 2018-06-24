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

class LandingPageViewController: UIViewController, GMSMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var landingPageMapView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var resultsLabel1: UILabel!
    @IBOutlet weak var resultsLabel2: UILabel!
    
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
                
        // load restaurants from firebase
        let restaurantsTable = Database.database().reference().child("Restaurants")
        restaurantsTable.observe(.childAdded, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                _ = getData["Sender"] as? String
                let restaurantBodyJSON = getData["RestaurantBody"] as? String
                let jsonData = restaurantBodyJSON?.data(using: .utf8)
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
                let restaurantDictionary = dictionary as! Dictionary<String, AnyObject>
                
                let name : String = restaurantDictionary["name"] as! String
//                print(name)
                let comments = restaurantDictionary["comments"] as! String
//                print(comments)
                let tags = restaurantDictionary["tags"] as! [String]
//                print(tags.count)
//                print(tags)
                
                
//                let restaurantVisits = restaurantDictionary["restaurantVisits"] as! [RestaurantVisit]
                var restaurantVisits = [RestaurantVisit]()

                let restaurantVisitDictionaries = restaurantDictionary["restaurantVisits"] as! [Dictionary<String, AnyObject>]
                for restaurantVisitDictionary in restaurantVisitDictionaries {
                    var restaurantVisit = RestaurantVisit()
//                    restaurantVisit.dateVisited = restaurantVisitDictionary["dateVisited"] as! Date
                    let val = restaurantVisitDictionary["dateVisited"] as AnyObject
                    print(type(of: val))
                    print(val)
                    let tsi = val as! TimeInterval
                    
//                    let myDateNow = Date.init(timeIntervalSinceNow: tsi)
//                    print(myDateNow)
                    
                    let myDateRD = Date.init(timeIntervalSinceReferenceDate: tsi)
                    print(myDateRD)

//                    let myDate1970 = Date.init(timeIntervalSince1970: tsi)
//                    print(myDate1970)
                    
                    restaurantVisit.dateVisited = myDateRD

                    restaurantVisits.append(restaurantVisit)
                }
                
//                let restaurantVisits = restaurantDictionary["restaurantVisits"] as AnyObject
//                let restaurantVisits = restaurantDictionary["restaurantVisits"] as! Optional<AnyObject>
//                print(restaurantVisits)
//
//                let rV = restaurantVisits
//                print(rV)
//                print(type(of: rV))
//
//                let rVs = rV as! [AnyObject]
//                print(rVs)
//                print(type(of: rVs))
//
//                print(rVs.count)
//                print(type(of: rVs[0]))
//                print(rVs[0])
//
//                let rv0 = rVs[0] as AnyObject
//                print(rv0)
//
//                let realRv0 = rv0 as! Dictionary<String, AnyObject>
//                print(realRv0)
//
//                let vType = type(of: restaurantVisits)
//                print("'\(restaurantVisits)' of type '\(vType)'")

                let location = restaurantDictionary["location"]
                let locationDictionary = location as! Dictionary<String, Double>
                let latitude = locationDictionary["latitude"]
                let longitude = locationDictionary["longitude"]
                
                var restaurant : Restaurant = Restaurant()
                restaurant.name = name
                restaurant.location = Location(latitude: latitude!, longitude: longitude!)
                restaurant.comments = comments
                
                for tag in tags {
                    restaurant.tags.append(tag)
                }

                restaurant.restaurantVisits = restaurantVisits

//                restaurant.restaurantVisits = restaurantVisits
                
//                for restaurantVisit in restaurantVisits {
//                    restaurant.restaurantVisits.append(restaurantVisit)
//                }
                
                print("after reading from db, add:")
                print(restaurant)
                self.restaurants.append(restaurant)
                
                var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
                coordinates.latitude = restaurant.location.latitude;
                coordinates.longitude = restaurant.location.longitude;
                
                let marker = GMSMarker(position: (coordinates))
                marker.title = restaurant.name
                marker.snippet = restaurant.comments
                marker.map = self.mapView
                marker.userData = restaurant
            }
            
            self.landingPageMapView.bringSubview(toFront: self.searchBar)
        })
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

//            print("Place name \(place.name)")
//            print("Place address \(place.formattedAddress)")
//            print("Place placeID \(place.placeID)")
//            print("Place attributions \(place.attributions)")
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
        print("Marker tapped")
        print ("marker is: \(marker)")
        print("Marker userData: \(marker.userData)")
        
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
        print("addButton pressed")
        
        if selectedRestaurant != nil {
            print("selectedRestaurant: \(String(describing: selectedRestaurant))")

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
            if let restaurantController = segue.destination as? RestaurantTVC {
                restaurantController.selectedRestaurant = selectedRestaurant
            }
        }
        
    }
    
    @IBAction func unwindToLandingPage(unwindSegue: UIStoryboardSegue) {
        print("unwindToLandingPage")
    }

}
