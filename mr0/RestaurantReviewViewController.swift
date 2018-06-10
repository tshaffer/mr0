//
//  RestaurantReviewViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/12/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import GooglePlaces

class RestaurantReviewViewController: UIViewController, SpecifyFoodTypeDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var visitDate: UIDatePicker!
    @IBOutlet weak var foodImage: UIImageView!
    
    var foodType: FoodType = .Other
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

    //a list to store photos
    var photos = [PhotoItem]()
    
    //the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return photos.count
    }
   
    //the method returning each cell of the list
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoItemCell", for: indexPath) as! PhotoItemTableViewCell
        
        //getting the photo for the specified position
        let photoItem: PhotoItem
        photoItem = photos[indexPath.row]
        
        let placeholderImage = UIImage(named: "xbutton.png")
        let downloadImageRef = photoItem.getStorageReference()
        let imageView: UIImageView! = cell.photoImageView!
        imageView.sd_setImage(with: downloadImageRef, placeholderImage: placeholderImage);

        cell.photoLabel.text = photoItem.label

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        listLikelyPlaces()
        
                self.photos.append(PhotoItem(
            fileName: "test.jpg",
            label: "photo 1",
            caption: ""))

        self.photos.append(PhotoItem(
            fileName: "A31045A7-76C0-42C3-BCBD-B3BB529DD817-10276-000007C405A1DE7F.jpg",
            label: "photo 2",
            caption: ""))

        self.photos.append(PhotoItem(
            fileName: "EC5730D2-9799-47B4-9860-A328F45B4618-10285-000007C577F0F3F1.jpg",
            label: "photo 3",
            caption: ""))
       
        //displaying data in tableview
        self.photosTableView.reloadData()
    }

    func specifyFoodType(foodType: FoodType) {
        print("specifyFoodType is \(foodType)")
        self.foodType = foodType
    }
    
    @IBAction func addPhoto(_ sender: Any) {
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
        }
    }
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
//                    print("place: \(place)")
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    

    @IBAction func submit(_ sender: UIButton) {
        print("button pressed")
        print(restaurantName.text!)
        print(comments.text!)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: visitDate.date)
        print(selectedDate)
        
        // add restaurant information to the database
        let restaurantsDB = Database.database().reference().child("Restaurants")
        
        var restaurant : Restaurant = Restaurant()
        restaurant.name = restaurantName.text!
//        restaurant.foodType = self.foodType
        restaurant.comments = comments.text!
//        restaurant.dateVisited = visitDate.date
//        restaurant.coordinates = (selectedPlace?.coordinate)!
//        restaurant.latitude = (selectedPlace?.coordinate)!.latitude
//        restaurant.longitude = (selectedPlace?.coordinate)!.longitude
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

    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("restaurant review prepare for segue invoked")
        
        if segue.identifier == "specifyFoodTypeSegue" {
            let vc = segue.destination as! FoodTypeTableViewController
            vc.specifyFoodTypeDelegate = self
        }
        else if (segue.identifier == "specifyLocationSegue") {
            print("segue to LocationTableViewController")
            if let nextViewController = segue.destination as? LocationTableViewController {
                nextViewController.likelyPlaces = likelyPlaces
            }

        }
        
    }
    
    // Update locaton / name
    @IBAction func unwindToRestaurantReview(segue: UIStoryboardSegue) {
         if selectedPlace != nil {
            print("user selected: \(selectedPlace!)")
            
            print("restaurant name: \(String(describing: selectedPlace?.name))")
            restaurantName.text = selectedPlace?.name
            
            // retrieve gps coordinates
            let coordinates : CLLocationCoordinate2D = (selectedPlace?.coordinate)!
            print("coordinates of selected place: \(coordinates)")
        }
        
        listLikelyPlaces()
    }
}


// Delegates to handle events for the location manager.
extension RestaurantReviewViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
}

extension String {
    
    /**
     Generates a unique string that can be used as a filename for storing data objects that need to ensure they have a unique filename. It is guranteed to be unique.
     
     - parameter prefix: The prefix of the filename that will be added to every generated string.
     - returns: A string that will consists of a prefix (if available) and a generated unique string.
     */
    static func uniqueFilename(withPrefix prefix: String? = nil) -> String {
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        
        if prefix != nil {
            return "\(prefix!)-\(uniqueString)"
        }
        
        return uniqueString
    }
    
}

