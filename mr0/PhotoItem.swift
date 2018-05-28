//
//  PhotoItem.swift
//  mr0
//
//  Created by Ted Shaffer on 5/28/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation
import FirebaseStorage

class PhotoItem {
    
    var storageReference: StorageReference?
    var label: String?
    var caption: String?
    
    init(storageReference: StorageReference?, label: String?, caption: String?) {
        self.storageReference = storageReference
        self.label = label
        self.caption = caption
    }
}
