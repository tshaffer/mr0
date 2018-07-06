//
//  RestaurantVC.swift
//  mr0
//
//  Created by Ted Shaffer on 6/30/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class RestaurantVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SaveCommentsDelegate, SetTagsDelegate, SaveMenuItemDelegate {
    
    @IBOutlet weak var menuItemsTable: UITableView!
    
    var selectedRestaurant: Restaurant?
    
    var comments: String = ""
    var specifiedTags: [Tag] = []
    var menuItems: [MenuItem] = []

    override func viewDidLoad() {
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

    func saveComments(comments: String) {
        self.comments = comments
    }
    
    func saveMenuItem(menuItem: MenuItem) {
        menuItems.append(menuItem)
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

//    @IBAction func unwindToRestaurantReview(segue: UIStoryboardSegue) {
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print ("RestaurantVC#prepare: segue.identifier is: \(String(describing: segue.identifier))")
        
        if (segue.identifier == "showRestaurantSummarySegue") {
            if let restaurantSummaryTVC = segue.destination as? RestaurantSummaryTVC {
                restaurantSummaryTVC.saveCommentsDelegate = self
                restaurantSummaryTVC.setTagsDelegate = self
                restaurantSummaryTVC.saveMenuItemDelegate = self
                restaurantSummaryTVC.selectedRestaurant = selectedRestaurant;
            }
        }
    }
    
    @IBAction func unwindToRestaurantReview(unwindSegue: UIStoryboardSegue) {
        print("unwindToRestaurantReview")
    }
}
