//
//  ViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 5/5/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class MemoRappViewController: UITableViewController {
        
    override func viewDidLoad() {
        print ("MemoRappViewController viewDidLoad")
        super.viewDidLoad()
    }

    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare invoked")
//        if segue.identifier == "Pizza"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
//        if segue.identifier == "Deep Dish"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
//        if segue.identifier == "Calzone"{
//            let vc = segue.destination as! PizzaMenuTableViewController
//            vc.delegate = self
//        }
        
    }
}


