//
//  ViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/5/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class MemoRappViewController: UITableViewController {

    let commandArray = ["Show Map", "Add Restaurant Review", "Add Photo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commandArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoRappItemCell", for: indexPath)
        
        cell.textLabel?.text = commandArray[indexPath.row]
        
        return cell
    }
}

