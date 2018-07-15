//
//  MenuItemCustomCell.swift
//  mr0
//
//  Created by Ted Shaffer on 7/15/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation
import UIKit

class MenuItemCustomCell: UITableViewCell {
    
    var menuItemLabel: String?
    var menuItemRating: String?
    
    var labelView: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
