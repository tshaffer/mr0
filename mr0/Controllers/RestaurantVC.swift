//
//  RestaurantVC.swift
//  mr0
//
//  Created by Ted Shaffer on 6/30/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI

protocol RestaurantDelegate {
    func getSelectedRestaurant() -> Restaurant
    func getSpecifiedTags() -> [Tag]
    func setSpecifiedTags(tags: [Tag])
}

class RestaurantVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveCommentsDelegate, SetTagsDelegate, SaveMenuItemDelegate, RestaurantDelegate {
    
    @IBOutlet weak var menuItemsTable: UITableView!
    
    var controllerDelegate: ControllerDelegate?

    var selectedRestaurant: Restaurant?
    var selectedMenuItem: MenuItem? = nil
    
    var specifiedTags: [Tag] = []

    override func viewDidLoad() {
        
        print ("RestaurantVC viewDidLoad")
        
        super.viewDidLoad()
        
        menuItemsTable.delegate = self
        menuItemsTable.dataSource = self
                
        for tagLabel in (selectedRestaurant?.tags)! {
            let tag = Tag(label: tagLabel)
            specifiedTags.append(tag)
        }
    }

    func getSelectedRestaurant() -> Restaurant {
        return selectedRestaurant!
    }
    
    func getSpecifiedTags() -> [Tag] {
        return specifiedTags
    }
    
    func setSpecifiedTags(tags:  [Tag]) {
        selectedRestaurant?.tags.removeAll()
        for tag in tags {
            selectedRestaurant?.tags.append(tag.label)
        }
    }
    
    func saveComments(comments: String) {
        selectedRestaurant?.comments = comments
    }
    
    func saveMenuItem(menuItem: MenuItem) {
        selectedRestaurant?.menuItems.append(menuItem)
        menuItemsTable.reloadData()
    }
    
    func setTags(tags: [Tag]) {
        specifiedTags = tags
        
        selectedRestaurant?.tags.removeAll()
        for tag in tags {
            selectedRestaurant?.tags.append(tag.label)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRestaurant!.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let label = selectedRestaurant?.menuItems[indexPath.row].name
        cell.textLabel?.text = label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cells = tableView.visibleCells
//        var cellIndex = 0
        
        selectedMenuItem = selectedRestaurant!.menuItems[indexPath.row]
        print("selectedMenuItem: \(String(describing: selectedMenuItem))")
//        performSegue(withIdentifier: "unwindToRestaurantReview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print ("RestaurantVC#prepare: segue.identifier is: \(String(describing: segue.identifier))")
        
        if (segue.identifier == "showRestaurantSummarySegue") {
            if let restaurantSummaryTVC = segue.destination as? RestaurantSummaryTVC {
                restaurantSummaryTVC.restaurantDelegate = self
                restaurantSummaryTVC.saveCommentsDelegate = self
                restaurantSummaryTVC.setTagsDelegate = self
                restaurantSummaryTVC.saveMenuItemDelegate = self
            }
        }
        else if (segue.identifier == "saveThenUnwindToLandingPageSegue") {
            saveRestaurant()
        }
        else if (segue.identifier == "showMenuItemSegue") {
            if let vc = segue.destination as? MenuItemViewController {
                vc.selectedMenuItem = selectedMenuItem
            }
        }
    }
    
    @IBAction func unwindToRestaurantReview(unwindSegue: UIStoryboardSegue) {
        print("unwindToRestaurantReview")
    }
    
    
    func saveRestaurant() {
        DBInterface.saveRestaurant(restaurantIn: selectedRestaurant!)
        controllerDelegate?.updateRestaurant(restaurant: selectedRestaurant!)
    }
}
