//
//  TagsViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/16/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var newTagNameTextField: UITextField!
    
    private var tags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // phoney data
        tags.append("Burgers")
        tags.append("Ice Cream")
        tags.append("Coffee")
        
        // Do any additional setup after loading the view.
        tagsTableView.delegate = self
        tagsTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = tags[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cells = tableView.visibleCells
//
//        for cell in cells {
//            cell.accessoryType = .none
//        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        switch indexPath.row {
//        case 0:
//            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Burrito)
//        case 1:
//            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Pizza)
//        case 2:
//            specifyFoodTypeDelegate?.specifyFoodType(foodType: .IceCream)
//        case 3:
//            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Burgers)
//        default:
//            specifyFoodTypeDelegate?.specifyFoodType(foodType: .Other)
//
//        }
    }
    
    @IBAction func addTagButton(_ sender: Any) {
    }
    

}
