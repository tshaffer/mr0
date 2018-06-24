//
//  RestaurantTVC.swift
//  mr0
//
//  Created by Ted Shaffer on 6/10/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import GooglePlaces


class RestaurantTVC: UITableViewController, UITextViewDelegate, SetVisitDateDelegate, SetTagsDelegate {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantTags: UILabel!
    @IBOutlet weak var restaurantComments: UITextView!
    @IBOutlet weak var visitDateLbl: UILabel!

    var selectedRestaurant: Restaurant?
    var selectedRestaurantVisitIndex: Int = 0
    var selectedPlaceName: String?
    
    var specifiedTags: [Tag] = []
    
    var visitDate: Date = Date.init()
    
    // OVERRIDDEN METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantName.text = selectedRestaurant?.name

        if selectedRestaurant?.comments == "" {
            restaurantComments.text = "Add restaurant comments..."
            restaurantComments.textColor = UIColor.lightGray
            restaurantComments.becomeFirstResponder()
            restaurantComments.selectedTextRange = restaurantComments.textRange(from: restaurantComments.beginningOfDocument, to: restaurantComments.beginningOfDocument)
        }
        else {
            restaurantComments.text = selectedRestaurant?.comments
        }
        restaurantComments.delegate = self
        
        for tagLabel in (selectedRestaurant?.tags)! {
            let newTag = Tag(label: tagLabel)
            specifiedTags.append(newTag)
        }
        restaurantTags.textColor = UIColor.lightGray

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        visitDate = (selectedRestaurant?.restaurantVisits[0].dateVisited)!
        let dateVisitLbl = dateFormatter.string(from: visitDate)
        visitDateLbl.text = dateVisitLbl
        
        selectedRestaurant?.restaurantVisits[self.selectedRestaurantVisitIndex].dateVisited = visitDate
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        // update ui fields that may have changed in a downstream view controller.
        updateTagsLabel()
        updateDateLabel()
    }
    
    // DELEGATE METHODS
    func specifyVisitDate(visitDate: Date) {
        self.visitDate = visitDate
        selectedRestaurant?.restaurantVisits[self.selectedRestaurantVisitIndex].dateVisited = visitDate
    }
    
    func setTags(tags: [Tag]) {
        print(tags)
        specifiedTags = tags
    }
    
    // MEMBER METHODS
    func populateSelectedRestaurantFromUI() {
        
        for tag in specifiedTags {
            selectedRestaurant?.tags.append(tag.label)
        }
        
        selectedRestaurant?.comments = restaurantComments.text
    }
    
    func updateTagsLabel() {
        var tagLabel = ""
        var textColor = UIColor.black
        if specifiedTags.count == 0 {
            tagLabel = "Specify tags here..."
            textColor = UIColor.lightGray
        }
        else {
            var index = 0
            for tag in specifiedTags {
                tagLabel += tag.label
                index += 1
                if (index < specifiedTags.count) {
                    tagLabel += ", "
                }
            }
        }
        restaurantTags.text = tagLabel
        restaurantTags.textColor = textColor
    }
    
    func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let currentVisitDate : Date =         (selectedRestaurant?.restaurantVisits[self.selectedRestaurantVisitIndex].dateVisited)!
        let dateVisitLbl = dateFormatter.string(from: currentVisitDate)
        visitDateLbl.text = dateVisitLbl
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Add restaurant comments..."
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func saveRestaurant() {
        
        populateSelectedRestaurantFromUI()
        
        print("saveRestaurant")
        print(restaurantName.text!)
        print(specifiedTags)
        print(restaurantComments.text!)
        
        // add restaurant information to the database
        let restaurantsDB = Database.database().reference().child("Restaurants")

        // flibbet
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {

            if (selectedRestaurant?.dbId == "") {
                selectedRestaurant?.dbId = UUID().uuidString
            }

            let data = try encoder.encode(selectedRestaurant)
            print(String(data: data, encoding: .utf8)!)
            let dataAsString = String(data: data, encoding: .utf8)!
            print(dataAsString)
            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
                                        "RestaurantBody": dataAsString] as [String : Any]
            
            //            restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
            restaurantsDB.child((selectedRestaurant?.dbId)!).setValue(restaurantDictionary) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print ("prepare: segue.identifier is: \(String(describing: segue.identifier))")
        if segue.identifier == "saveThenUnwindToLandingPageSegue" {
            self.saveRestaurant()
        }
        else if (segue.identifier == "cancelThenUnwindToLandingPageSegue") {
            print("operation cancelled");
        }
        if segue.identifier == "setVisitDateSegue" {
            let vc = segue.destination as! DatePickerViewController
            vc.setVisitDateDelegate = self
        }
        else if segue.identifier == "showTagsViewControllerSegue" {
            let vc = segue.destination as! TagsViewController
            vc.setTagsDelegate = self
            vc.restaurantTags = self.specifiedTags
        }
    }
}
