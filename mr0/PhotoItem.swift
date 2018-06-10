//
//  PhotoItem.swift
//  mr0
//
//  Created by Ted Shaffer on 5/28/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import Foundation
import FirebaseStorage

class PhotoItem : Codable {
    
//    var storageReference: StorageReference?
    let fileName: String
    var label: String?
    var caption: String?
    
    init(fileName: String, label: String?, caption: String?) {
        self.fileName = fileName
        self.label = label
        self.caption = caption
    }
    
    func getStorageReference() -> StorageReference {
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
    
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
    
        return storageRef.child("images/" + self.fileName)
    }
}
