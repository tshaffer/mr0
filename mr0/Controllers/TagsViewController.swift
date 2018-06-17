//
//  TagsViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/16/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

protocol SetTagsDelegate {
    func setTagIndices(tags: [String])
}

class TagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var setTagsDelegate : SetTagsDelegate?

    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var newTagNameTextField: UITextField!
    
    var tags: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cells = tableView.visibleCells
        var cellIndex = 0
        var selectedTags: [String] = []
        
        for cell in cells {
            if (cell.accessoryType == .checkmark) {
                selectedTags.append(self.tags[cellIndex])
            }
            cellIndex += 1
        }
        
        setTagsDelegate?.setTagIndices(tags: selectedTags)
    }
    
    @IBAction func addTagButton(_ sender: Any) {
    }
    

}
