//
//  RestaurantViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/5/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import GooglePlaces

class RestaurantViewController: UIViewController, SpecifyFoodTypeDelegate {

    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var visitDateBtn: UIButton!
    @IBOutlet weak var foodImage: UIImageView!

    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()
    var selectedDate: String = ""

    var foodType: FoodType = .Other

    var visitDate : Date = Date.init()

    @IBAction func swipeVisitLeft(_ sender: UISwipeGestureRecognizer) {
        print(" swipe left")
    }
    @IBAction func swipeVisitRight(_ sender: UISwipeGestureRecognizer) {
        print(" swipe right")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        restaurantName.text = selectedPlace!.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        selectedDate = dateFormatter.string(from: visitDate)
        visitDateBtn.setTitle(selectedDate,for: .normal)

        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func setFoodTypes(_ sender: Any) {
    }
    
    @IBAction func setVisitDate(_ sender: Any) {
    }
    
    @IBAction func addPhotoClicked(_ sender: Any) {
        
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            
            // Get a reference to the storage service using the default Firebase App
            let storage = Storage.storage()
            
            // Create a storage reference from our storage service
            let storageRef = storage.reference()
            
            // Example code to download and display test image
            //            // Reference to an image file in Firebase Storage
            //            let downloadImageRef = storageRef.child("images/test.jpg")
            //
            //            // Load the image using SDWebImage
            //            // Placeholder image
            //            let placeholderImage = UIImage(named: "xbutton.png")
            //            self.foodImage.sd_setImage(with: downloadImageRef, placeholderImage: placeholderImage)
            // end of example code
            
            /* get your image here */
            print("image received")
            self.foodImage.image = image
            
            // Create a child reference
            // imagesRef now points to "images"
            let imagesRef = storageRef.child("images")
            
            let fileName = String.uniqueFilename() + ".jpg"
            print("fileName = \(fileName)")
            let testPhotoRef = imagesRef.child(fileName)
            
            // Data in memory
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            
            // Upload the file to the path "images/test.jpg"
            testPhotoRef.putData(imageData!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("error")
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                print("size= \(size)")
            }
        }}
    
    func specifyFoodType(foodType: FoodType) {
        print("specifyFoodType is \(foodType)")
        self.foodType = foodType
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant review prepare for segue invoked")
        
        if segue.identifier == "specifyFoodTypeSegue" {
            let vc = segue.destination as! FoodTypeTableViewController
            vc.specifyFoodTypeDelegate = self
        }
        
        
    }

    @IBAction func submitRestaurantBtn(_ sender: Any) {
        
        // add restaurant information to the database
        let restaurantsDB = Database.database().reference().child("Restaurants")
        
        var restaurant : Restaurant = Restaurant()
        restaurant.name = restaurantName.text!
        restaurant.foodType = self.foodType
        restaurant.comments = comments.text!
        restaurant.dateVisited = visitDate
        restaurant.location = Location(latitude: (selectedPlace?.coordinate)!.latitude, longitude: (selectedPlace?.coordinate)!.longitude);
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(restaurant)
            print(String(data: data, encoding: .utf8)!)
            let dataAsString = String(data: data, encoding: .utf8)!
            print(dataAsString)
            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
                                        "RestaurantBody": dataAsString] as [String : Any]
            restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
                (error, reference) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    print("Restaurant saved successfully")
                }
            }
        }
        catch {
            print("encoder error")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
