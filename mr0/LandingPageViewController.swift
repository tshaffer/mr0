//
//  LandingPageViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/3/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import GoogleMaps

class LandingPageViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var landingPageMapView: UIView!
    
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    
    let defaultLocation = CLLocation(latitude: 37.397686, longitude: -122.061104)
    
    var restaurants = [Restaurant]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    private func mapView(_ mapView: GMSMapView, didTapMarker marker: GMSMarker) {
        print("You didTapMarker")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
