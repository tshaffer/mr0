//
//  RestaurantSummaryTVC.swift
//  mr0
//
//  Created by Ted Shaffer on 6/30/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

protocol SaveCommentsDelegate {
    func saveComments(comments: String)
}

class RestaurantSummaryTVC: UITableViewController, UITextViewDelegate {
    
    var restaurantDelegate: RestaurantDelegate?
    var saveCommentsDelegate : SaveCommentsDelegate?
    var setTagsDelegate : SetTagsDelegate?
    var saveMenuItemDelegate : SaveMenuItemDelegate?
    
    @IBOutlet var restaurantSummaryTableView: UITableView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var comments: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let selectedRestaurant: Restaurant = (restaurantDelegate?.getSelectedRestaurant())!
        
        if selectedRestaurant.comments == "" {
            comments.text = "Add restaurant comments..."
            comments.textColor = UIColor.lightGray
            comments.becomeFirstResponder()
            comments.selectedTextRange = comments.textRange(from: comments.beginningOfDocument, to: comments.beginningOfDocument)
        }
        else {
            comments.text = selectedRestaurant.comments
        }
        comments.delegate = self
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (section == 0) {
            let header = view as! UITableViewHeaderFooterView
            let selectedRestaurant: Restaurant = (restaurantDelegate?.getSelectedRestaurant())!
            header.textLabel?.text = selectedRestaurant.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // update ui fields that may have changed in a downstream view controller.
        updateTagsLabel()
//        updateRatingLabel()
//        updateDateLabel()
    }
    
    
    // MEMBER METHODS
//    @IBAction func ratingChanged(_ sender: UISlider) {
//        let rating = Float(Float(sender.value) / 10)
//        selectedRestaurant?.rating = rating
//        let ratingAsString = (String(format: "%.01f", rating))
//        ratingLabel.text = "Restaurant rating: \(ratingAsString)"
//    }
    
    func updateTagsLabel() {
        
        let specifiedTags = (restaurantDelegate?.getSpecifiedTags())!

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
        tags.text = tagLabel
        tags.textColor = textColor
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        saveCommentsDelegate?.saveComments(comments: updatedText)

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
    
    @IBAction func addMenuItem(_ sender: Any) {
        print("addMenuItem")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print ("RestaurantSummaryTVC#prepare: segue.identifier is: \(String(describing: segue.identifier))")
        
//        if segue.identifier == "saveThenUnwindToLandingPageSegue" {
////            self.saveRestaurant()
//        }
//        else if (segue.identifier == "cancelThenUnwindToLandingPageSegue") {
//            print("operation cancelled");
//        }
//        if segue.identifier == "setVisitDateSegue" {
//            let vc = segue.destination as! DatePickerViewController
////            vc.setVisitDateDelegate = self
//        }
        if segue.identifier == "showTagsViewControllerSegue" {
            let vc = segue.destination as! TagsViewController
            vc.setTagsDelegate = self.setTagsDelegate
            vc.restaurantTags = (restaurantDelegate?.getSpecifiedTags())!
        }
        else if segue.identifier == "addMenuItemSegue" {
            let vc = segue.destination as! MenuItemViewController
            vc.saveMenuItemDelegate = self.saveMenuItemDelegate
        }
    }
}
