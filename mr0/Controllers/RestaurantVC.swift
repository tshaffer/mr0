//
//  RestaurantVC.swift
//  mr0
//
//  Created by Ted Shaffer on 6/30/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class RestaurantVC: UIViewController {

    var selectedRestaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("RestaurantVC viewDidLoad")
        print("selectedRestaurant = \(String(describing: selectedRestaurant))")

        // Do any additional setup after loading the view.
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("RestaurantVC prepare invoked")
        print("segueIdentifier = \(String(describing: segue.identifier))")
        
        if (segue.identifier == "showRestaurantSummarySegue") {
            if let restaurantSummaryTVC = segue.destination as? RestaurantSummaryTVC {
                restaurantSummaryTVC.selectedRestaurant = selectedRestaurant;
            }
        }
        //        if (segue.identifier == "addRestaurantSegue") {
        //            if let restaurantController = segue.destination as? RestaurantTVC {
        //                restaurantController.selectedRestaurant = selectedRestaurant
        //            }
        //        }
        
    }
}
