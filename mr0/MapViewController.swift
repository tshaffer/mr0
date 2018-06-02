//
//  MapViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/2/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0

    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        view.addSubview(mapView)
//        mapView.isHidden = true
        mapView.isHidden = false

/*
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
 */
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
