//
//  RestaurantTableViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class FoodTypeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("food type prepare for segue invoked")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cells = self.tableView.visibleCells
        
        for cell in cells {
            cell.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
