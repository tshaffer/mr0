//
//  MenuItemViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 7/1/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

protocol SaveMenuItemDelegate {
    func saveMenuItem(menuItem: MenuItem)
}

// flibbet
class MenuItemViewController: UIViewController, UITextViewDelegate  {

    var saveMenuItemDelegate : SaveMenuItemDelegate?

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var menuItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        comments.text = "Add restaurant comments..."
        comments.textColor = UIColor.lightGray
        comments.becomeFirstResponder()
        comments.selectedTextRange = comments.textRange(from: comments.beginningOfDocument, to: comments.beginningOfDocument)
//        if selectedRestaurant?.comments == "" {
//            comments.text = "Add restaurant comments..."
//            comments.textColor = UIColor.lightGray
//            comments.becomeFirstResponder()
//            comments.selectedTextRange = comments.textRange(from: comments.beginningOfDocument, to: comments.beginningOfDocument)
//        }
//        else {
//            comments.text = selectedRestaurant?.comments
//        }
        comments.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // update ui fields that may have changed in a downstream view controller.
        updateRatingLabel()
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
    
    func updateRatingLabel() {
        let rating = Float(Float(ratingSlider.value) / 10)
        let ratingAsString = (String(format: "%.01f", rating))
        ratingLabel.text = "Rating: \(ratingAsString)"
    }
    
    @IBAction func ratingChanged(_ sender: UISlider) {
        let rating = Float(Float(sender.value) / 10)
        menuItem?.rating = rating
        let ratingAsString = (String(format: "%.01f", rating))
        ratingLabel.text = "Rating: \(ratingAsString)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print ("menuItemViewController#prepare: segue.identifier is: \(String(describing: segue.identifier))")
        
        if segue.identifier == "saveThenUnwindToRestaurantReviewSegue" {
            saveMenu()
        }
        else if (segue.identifier == "cancelThenUnwindToRestaurantReview") {
            print("operation cancelled");
        }
    }
    
    func saveMenu() {
        var menuItem = MenuItem(name : name.text!)
        menuItem.comments = comments.text!
        menuItem.rating = ratingSlider.value / 10
        print("MenuItem: ", menuItem)
        
        saveMenuItemDelegate?.saveMenuItem(menuItem: menuItem)
    }
}
