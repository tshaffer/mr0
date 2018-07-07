//
//  TagsViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/16/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI

protocol SetTagsDelegate {
    func setTags(tags: [Tag])
}

class TagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var setTagsDelegate : SetTagsDelegate?

    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var newTagNameTextField: UITextField!
    
    var tags = [Tag]()
    var restaurantTags = [Tag]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tagsTableView.delegate = self
        tagsTableView.dataSource = self
        
        // load restaurant type tags from firebase
        let restaurantTypeTagsTable = Database.database().reference().child("RestaurantTypeTags")
        restaurantTypeTagsTable.observe(.childAdded, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                _ = getData["Sender"] as? String
                let restaurantTypeTagsJSON = getData["Tag"] as? String
                let jsonData = restaurantTypeTagsJSON?.data(using: .utf8)
                let dictionary = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
                let restaurantTypeTagsDictionary = dictionary as! Dictionary<String, AnyObject>
                
                let tagLabel = restaurantTypeTagsDictionary["label"]
                let tag = Tag(label: tagLabel as! String)
                
                self.tags.append(tag)
            }
            self.tagsTableView.reloadData()
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        
        let label = tags[indexPath.row].label

        var restaurantLabels = [String]()
        for restaurantTag in restaurantTags {
            restaurantLabels.append(restaurantTag.label)
        }
        if restaurantLabels.contains(label) {
            cell.accessoryType = .checkmark
        }

        cell.textLabel?.text = label

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cells = tableView.visibleCells
        var cellIndex = 0
        var selectedTags: [Tag] = []
        
        for cell in cells {
            if (cell.accessoryType == .checkmark) {
                selectedTags.append(self.tags[cellIndex])
            }
            cellIndex += 1
        }
        
        setTagsDelegate?.setTags(tags: selectedTags)
    }
    
    @IBAction func addTagButton(_ sender: Any) {

        let newTag : Tag = Tag(label: newTagNameTextField.text!)
        tagsTableView.reloadData()
        
        // add new tag to database
        let restaurantTypeTagsTable = Database.database().reference().child("RestaurantTypeTags")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(newTag)
            print(String(data: data, encoding: .utf8)!)
            let dataAsString = String(data: data, encoding: .utf8)!
            print(dataAsString)
            let restaurantTypeTagsDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
                                        "Tag": dataAsString] as [String : Any]
            restaurantTypeTagsTable.childByAutoId().setValue(restaurantTypeTagsDictionary) {
                (error, reference) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    print("Tag saved successfully")
                }
            }
        }
        catch {
            print("encoder error")
        }
    }
}
