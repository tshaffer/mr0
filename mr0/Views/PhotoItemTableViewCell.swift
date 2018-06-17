//
//  PhotoItemTableViewCell.swift
//  mr0
//
//  Created by Ted Shaffer on 5/28/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

class PhotoItemTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
