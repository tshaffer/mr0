//
//  RestaurantTableViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

enum FoodType : CustomStringConvertible {
    case Burrito
    case Pizza
    case IceCream
    case Burgers
    case Other
    
    var description : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .Burrito: return "Burrito"
        case .Pizza: return "Pizza"
        case .IceCream: return "Ice Cream"
        case .Burgers: return "Burgers"
        case .Other: return "Other"
        }
    }
}

protocol SpecifyFoodTypeDelegate {
    func specifyFoodType(foodType: FoodType)
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
            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Burrito)
        case 1:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Pizza)
        case 2:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: .IceCream)
        case 3:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Burgers)
        default:
            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Other)

        }
    }
    
    
}
