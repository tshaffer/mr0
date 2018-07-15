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
        menuItemsTable.register(UINib(nibName: "menuItemCustomCell", bundle: nil),
                                forCellReuseIdentifier: "menuItemCustomCell")
        
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
        print("saveMenuItem")
        selectedRestaurant?.menuItems.append(menuItem)
        menuItemsTable.reloadData()
    }
   
    func getMatchingMenuItem(menuItemToMatch: MenuItem) -> Int
    {
        var index = 0;
        for menuItem in (selectedRestaurant?.menuItems)! {
            if (menuItem.name == menuItemToMatch.name) {
                return index;
            }
            index = index + 1
        }
        
        return -1
    }
    func overwriteMenuItem(menuItem: MenuItem) {
        print("overwriteMenuItem")
        let menuItemIndex = getMatchingMenuItem(menuItemToMatch: menuItem)
        if (menuItemIndex >= 0) {
            selectedRestaurant?.menuItems[menuItemIndex] = menuItem
            menuItemsTable.reloadData()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCustomCell", for: indexPath) as! menuItemCustomCell
        
        cell.label?.text = selectedRestaurant?.menuItems[indexPath.row].name
        
        let ratingAsString = (String(format: "%.01f", (selectedRestaurant?.menuItems[indexPath.row].rating)! / 10))
        cell.rating?.text = ratingAsString
        
//        let label = selectedRestaurant?.menuItems[indexPath.row].name
//        cell.textLabel?.text = label
        return cell
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
            
            let cell = sender as! UITableViewCell
            let index = menuItemsTable.indexPath(for: cell)
            selectedMenuItem = selectedRestaurant!.menuItems[(index?.row)!]
            print("selectedMenuItem: \(String(describing: selectedMenuItem))")
            
            if let vc = segue.destination as? MenuItemViewController {
                vc.selectedMenuItem = selectedMenuItem
                vc.saveMenuItemDelegate = self
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
