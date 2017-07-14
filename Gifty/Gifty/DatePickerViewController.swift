//
//  DatePickerViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-13.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol datePickerViewControllerDelegate {
    func didSetDate(_ date: Date?)
}

class DatePickerViewController: CustomViewController {

    var delegate: datePickerViewControllerDelegate?
    
    var monthYearLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.blue
        label.font = FontManager.titleText
        label.textColor = UIColor.white
        return label
    }()
    
    var calendar: CustomCalendar!
    
    var initialDate: Date?
    
    var selectedDate: Date?
    
    var addDateToEventButton: ButtonTemplate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Event Date"
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "< BACK", style: .plain, target: self, action: #selector(backButtonTouched))
        self.navigationItem.leftBarButtonItem = backButton
        
        setupSubViews()
    }

    fileprivate func setupSubViews() {
        if calendar != nil {
            calendar.removeFromSuperview()
            calendar = nil
        }
        
        var yVal: CGFloat = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.height + pad
        let leftPad: CGFloat = (self.view.bounds.width / 8) - 10
            
        monthYearLabel.frame = CGRect(x: leftPad, y: yVal, width: self.view.bounds.width - (2 * pad), height: 26)
        view.addSubview(monthYearLabel)
        
        yVal += monthYearLabel.frame.height + pad

        calendar = CustomCalendar(frame: CGRect(x: pad, y: yVal, width: self.view.bounds.width - (2 * pad), height: 300))
        calendar.delegate = self
        
        if self.initialDate != nil {
            calendar.initiallySelectedDate = initialDate
        }
        
        view.addSubview(calendar)
        
        guard let tabBarHeight: CGFloat = self.tabBarController?.tabBar.bounds.height else { return }
        
        let buttonframe = CGRect(x: pad, y: view.bounds.height - tabBarHeight - pad - 35, width: view.bounds.width - pad - pad, height: 35)
        addDateToEventButton = ButtonTemplate(frame: buttonframe, title: "ADD DATE TO EVENT")
        addDateToEventButton.delegate = self
        view.addSubview(addDateToEventButton)
    }
    

}

//MARK: Back button method
extension DatePickerViewController {

    func backButtonTouched() {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "continuing this action will return you to your event without assigning a date", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            if self.delegate != nil {
                self.delegate?.didSetDate(nil)
            }
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //do nothing??
        }
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


//MARK: Calendar delegate methods
extension DatePickerViewController: CustomCalendarDelegate {
    
    func hideShowInfoForSelectedDate(_ date: Date, show: Bool) {
        if show {
            self.selectedDate = date
        } else {
            self.selectedDate = nil
        }
        print("\(String(describing: self.selectedDate))")
    }
    
    func monthYearLabelWasUpdated(_ string: String) {
        self.monthYearLabel.text = string
    }
}

extension DatePickerViewController: ButtonTemplateDelegate {

    func buttonWasTouched() {
        
        if self.selectedDate != nil && self.delegate != nil {
            self.delegate?.didSetDate(self.selectedDate)
            self.navigationController?.popViewController(animated: true)

        } else {
            let alertController = UIAlertController(title: "No date selected", message: "please select a date before adding it to your event", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //do nothing
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
