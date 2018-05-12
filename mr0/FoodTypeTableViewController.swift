//
//  RestaurantTableViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

protocol SpecifyFoodTypeDelegate {
    func specifyFoodType(foodType: String)
}

class FoodTypeTableViewController: UITableViewController, UINavigationControllerDelegate {

    var specifyFoodTypeDelegate : SpecifyFoodTypeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
    }

    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        print("foodTypeTableViewController::viewWillDisappear")
        
        if self.isMovingFromParentViewController {
            print("isMovingFromParentViewController")
        }
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
        
        switch indexPath.row {
        case 0:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: "burrito")
        case 1:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: "pizza")
        case 2:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: "ice cream")
        case 3:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: "burgers")
        default:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: "some other food")

        }
    }
    
    
}
