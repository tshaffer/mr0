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
    func getMenuItems() -> [MenuItem]
}

class RestaurantVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveCommentsDelegate, SetTagsDelegate, SaveMenuItemDelegate, RestaurantDelegate {
    
    @IBOutlet weak var menuItemsTable: UITableView!
    
    var selectedRestaurant: Restaurant?
    
    var comments: String = ""
    var specifiedTags: [Tag] = []
    var menuItems: [MenuItem] = []

    override func viewDidLoad() {
        
        print ("RestaurantVC viewDidLoad")
        
        super.viewDidLoad()
        
        menuItemsTable.delegate = self
        menuItemsTable.dataSource = self
        
        print("RestaurantVC viewDidLoad")
        print("selectedRestaurant = \(String(describing: selectedRestaurant))")

        var mi = MenuItem(name: "Burrito - Pollo Borracho")
        menuItems.append(mi)
        mi = MenuItem(name: "Tres Tacos")
        menuItems.append(mi)
    }

    func getSelectedRestaurant() -> Restaurant {
        return selectedRestaurant!
    }
    
    func getSpecifiedTags() -> [Tag] {
        return specifiedTags
    }
    
    func getMenuItems() -> [MenuItem] {
        return menuItems
    }
    
    func saveComments(comments: String) {
        self.comments = comments
    }
    
    func saveMenuItem(menuItem: MenuItem) {
        menuItems.append(menuItem)
        menuItemsTable.reloadData()
    }
    
    func setTags(tags: [Tag]) {
        specifiedTags = tags
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        let label = menuItems[indexPath.row].name
        cell.textLabel?.text = label
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
    }
    
    @IBAction func unwindToRestaurantReview(unwindSegue: UIStoryboardSegue) {
        print("unwindToRestaurantReview")
    }
    
    func populateSelectedRestaurantFromUI() {
        
        selectedRestaurant?.comments = comments
        
        selectedRestaurant?.tags.removeAll()
        for tag in specifiedTags {
            selectedRestaurant?.tags.append(tag.label)
        }
        
        selectedRestaurant?.menuItems = menuItems
    }
    
    func saveRestaurant() {

        populateSelectedRestaurantFromUI()

        let restaurantsDB = Database.database().reference().child("Restaurants")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {

            if (selectedRestaurant?.dbId == "") {
                selectedRestaurant?.dbId = UUID().uuidString
            }

            let data = try encoder.encode(selectedRestaurant)
            print(String(data: data, encoding: .utf8)!)
            let dataAsString = String(data: data, encoding: .utf8)!
            print(dataAsString)
            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
                                        "RestaurantBody": dataAsString] as [String : Any]

            restaurantsDB.child((selectedRestaurant?.dbId)!).setValue(restaurantDictionary) {
                (error, reference) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    print("Restaurant saved successfully")
                }
            }
        }
        catch {
            print("encoder error")
        }
    }
}
