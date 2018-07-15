//
//  menuItemCustomCell.swift
//  mr0
//
//  Created by Ted Shaffer on 7/15/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class menuItemCustomCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
