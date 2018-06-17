//
//  DatePickerViewController.swift
//  mr0
//
//  Created by Ted Shaffer on 6/10/18.
//  Copyright © 2018 Ted Shaffer. All rights reserved.
//

import UIKit

protocol SetVisitDateDelegate {
    func specifyVisitDate(visitDate: Date)
}

class DatePickerViewController: UIViewController {

    var setVisitDateDelegate : SetVisitDateDelegate?

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
   }

//    override func viewWillDisappear(_ animated : Bool) {
//        super.viewWillDisappear(animated)
//
//        print("DatePickerViewController::viewWillDisappear")
//
//        if self.isMovingFromParentViewController {
//            print("isMovingFromParentViewController")
//        }
//    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            
            let calendar = Calendar(identifier: .gregorian)
            let selectedDate = calendar.date(from: DateComponents(year: year, month: month, day: day))
            setVisitDateDelegate?.specifyVisitDate(visitDate: selectedDate!)
        }
    }
}
