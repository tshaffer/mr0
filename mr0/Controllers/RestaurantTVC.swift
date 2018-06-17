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

    var selectedPlace: GMSPlace?
    var selectedLocation = CLLocationCoordinate2D()
    
    var visitDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantName.text = selectedPlace!.name
        
        restaurantTags.textColor = UIColor.lightGray
        
        restaurantComments.delegate = self
        restaurantComments.text = "Add restaurant comments..."
        restaurantComments.textColor = UIColor.lightGray
        restaurantComments.becomeFirstResponder()
        restaurantComments.selectedTextRange = restaurantComments.textRange(from: restaurantComments.beginningOfDocument, to: restaurantComments.beginningOfDocument)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        visitDate = Date.init()
        let dateVisitLbl = dateFormatter.string(from: visitDate!)
        visitDateLbl.text = dateVisitLbl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateVisitLbl = dateFormatter.string(from: visitDate!)
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
    
    func specifyVisitDate(visitDate: Date) {
         self.visitDate = visitDate
    }
    
    func setTags(tags: [Tag]) {
        print(tags)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setVisitDateSegue" {
            let vc = segue.destination as! DatePickerViewController
            vc.setVisitDateDelegate = self
        }
        else if segue.identifier == "showTagsViewControllerSegue" {
            let vc = segue.destination as! TagsViewController
            vc.setTagsDelegate = self

//            var tags: [String] = []
//            tags.append("Burgers")
//            tags.append("Ice Cream")
//            tags.append("Coffee")
//            tags.append("Pizza")
//            vc.restaurantTypeTags = tags
        }
    }
}
