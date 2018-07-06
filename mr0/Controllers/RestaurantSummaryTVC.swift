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

// flibbet
class RestaurantSummaryTVC: UITableViewController, UITextViewDelegate, SetTagsDelegate, SaveMenuItemDelegate {
    
    var saveCommentsDelegate : SaveCommentsDelegate?
    var setTagsDelegate : SetTagsDelegate?
    var saveMenuItemDelegate : SaveMenuItemDelegate?
    
    @IBOutlet var restaurantSummaryTableView: UITableView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var comments: UITextView!
    
    var selectedRestaurant: Restaurant?

    var specifiedTags: [Tag] = []
    var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("restaurantSummaryTableView: \(String(describing: restaurantSummaryTableView))")
        
        print("tableViewHeader: \(String(describing: restaurantSummaryTableView.tableHeaderView ))")
        
        if selectedRestaurant?.comments == "" {
            comments.text = "Add restaurant comments..."
            comments.textColor = UIColor.lightGray
            comments.becomeFirstResponder()
            comments.selectedTextRange = comments.textRange(from: comments.beginningOfDocument, to: comments.beginningOfDocument)
        }
        else {
            comments.text = selectedRestaurant?.comments
        }
        comments.delegate = self

        for tagLabel in (selectedRestaurant?.tags)! {
            let newTag = Tag(label: tagLabel)
            specifiedTags.append(newTag)
        }
        tags.textColor = UIColor.lightGray
        
        print("RestaurantSummaryTVC viewDidLoad")
        print("selectedRestaurant = \(String(describing: selectedRestaurant))")
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (section == 0) {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.text = selectedRestaurant?.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // update ui fields that may have changed in a downstream view controller.
        updateTagsLabel()
//        updateRatingLabel()
//        updateDateLabel()
    }
    
    // FLIBBET
    // need to invoke delegate methods on RestaurantVC to save Tags and comments
    
    // DELEGATE METHODS
    func setTags(tags: [Tag]) {
        print(tags)
        specifiedTags = tags
        
        setTagsDelegate?.setTags(tags: specifiedTags)
    }
    
    // flibbet
    func saveMenuItem(menuItem: MenuItem) {
        menuItems.append(menuItem)
        saveMenuItemDelegate?.saveMenuItem(menuItem: menuItem)
    }
    
    // MEMBER METHODS
//    @IBAction func ratingChanged(_ sender: UISlider) {
//        let rating = Float(Float(sender.value) / 10)
//        selectedRestaurant?.rating = rating
//        let ratingAsString = (String(format: "%.01f", rating))
//        ratingLabel.text = "Restaurant rating: \(ratingAsString)"
//    }
    
    func populateSelectedRestaurantFromUI() {
        
        for tag in specifiedTags {
            selectedRestaurant?.tags.append(tag.label)
        }
        
        selectedRestaurant?.comments = comments.text
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
    
    // flibbet
    @IBAction func addMenuItem(_ sender: Any) {
        print("addMenuItem")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print ("RestaurantSummaryTVC#prepare: segue.identifier is: \(String(describing: segue.identifier))")
        
        if segue.identifier == "saveThenUnwindToLandingPageSegue" {
//            self.saveRestaurant()
        }
        else if (segue.identifier == "cancelThenUnwindToLandingPageSegue") {
            print("operation cancelled");
        }
        if segue.identifier == "setVisitDateSegue" {
            let vc = segue.destination as! DatePickerViewController
//            vc.setVisitDateDelegate = self
        }
        else if segue.identifier == "showTagsViewControllerSegue" {
            let vc = segue.destination as! TagsViewController
            vc.setTagsDelegate = self
            vc.restaurantTags = self.specifiedTags
        }
        else if segue.identifier == "addMenuItemSegue" {
            let vc = segue.destination as! MenuItemViewController
            vc.saveMenuItemDelegate = self
        }
    }
    
    // flibbet
    
//    func saveRestaurant() {
//        
//        populateSelectedRestaurantFromUI()
//        
//        print("saveRestaurant")
//        print(restaurantName.text!)
//        print(specifiedTags)
//        print(restaurantComments.text!)
//        
//        // add restaurant information to the database
//        let restaurantsDB = Database.database().reference().child("Restaurants")
//        
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        
//        do {
//            
//            if (selectedRestaurant?.dbId == "") {
//                selectedRestaurant?.dbId = UUID().uuidString
//            }
//            
//            let data = try encoder.encode(selectedRestaurant)
//            print(String(data: data, encoding: .utf8)!)
//            let dataAsString = String(data: data, encoding: .utf8)!
//            print(dataAsString)
//            let restaurantDictionary = ["Sender": Auth.auth().currentUser?.email ?? "ted@roku.com",
//                                        "RestaurantBody": dataAsString] as [String : Any]
//            
//            //            restaurantsDB.childByAutoId().setValue(restaurantDictionary) {
//            restaurantsDB.child((selectedRestaurant?.dbId)!).setValue(restaurantDictionary) {
//                (error, reference) in
//                if (error != nil) {
//                    print(error!)
//                }
//                else {
//                    print("Restaurant saved successfully")
//                }
//            }
//        }
//        catch {
//            print("encoder error")
//        }
//    }
//    
//    func populateSelectedRestaurantFromUI() {
//        
//        for tag in specifiedTags {
//            selectedRestaurant?.tags.append(tag.label)
//        }
//        
//        selectedRestaurant?.comments = restaurantComments.text
//    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
