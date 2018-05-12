//
//  RestaurantTableViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare invoked")
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
