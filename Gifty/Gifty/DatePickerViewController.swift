//
//  DatePickerViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-13.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol DatePickerViewControllerDelegate {
    func didSetDate(_ date: Date?)
}

class DatePickerViewController: CustomViewController {

    var delegate: DatePickerViewControllerDelegate?
    
    var calendar: CustomCalendar!
    
    var initialDate: Date?
    
    var selectedDate: Date?
    
    var addDateToEventButton: ButtonTemplate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue), style: .plain, target: self, action: #selector(backButtonTouched))
        self.navigationItem.leftBarButtonItem = backButton
        
        setupSubViews()
    }

    fileprivate func setupSubViews() {
        if calendar != nil {
            calendar.removeFromSuperview()
            calendar = nil
        }
        
        var yVal: CGFloat = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.height + pad

        calendar = CustomCalendar(frame: CGRect(x: pad, y: yVal, width: self.view.bounds.width - (2 * pad), height: 300))
        calendar.delegate = self
        
        view.addSubview(calendar)
        
        yVal += calendar.frame.height + pad
        
        let buttonframe = CGRect(x: pad, y: yVal, width: view.bounds.width - pad - pad, height: 35)
        addDateToEventButton = ButtonTemplate(frame: buttonframe)
        addDateToEventButton.backgroundColor = UIColor.clear
        addDateToEventButton.setTitle("ADD DATE")
        addDateToEventButton.addBorder(with: UIColor.white)
        addDateToEventButton.delegate = self
        view.addSubview(addDateToEventButton)
        
        if selectedDate != nil {
            DispatchQueue.main.async {
                self.calendar.scrollToSelectedDate(self.selectedDate!)
            }
        }
    }
}

//MARK: Back button method
extension DatePickerViewController {

    @objc func backButtonTouched() {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "Continuing this action will return you to your event without assigning a date", preferredStyle: .alert)
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
            let dateString = DateHandler.stringFromDate(date)
            let dateNoTime = DateHandler.dateFromDateString(dateString)
            self.selectedDate = dateNoTime
        } else {
            self.selectedDate = nil
        }
        print("\(String(describing: self.selectedDate))")
    }
    
    func monthYearLabelWasUpdated(_ string: String) {
        self.title = string
    }
}

extension DatePickerViewController: ButtonTemplateDelegate {

    func buttonWasTouched() {
        
        if self.selectedDate != nil && self.delegate != nil {
            self.delegate?.didSetDate(self.selectedDate)
            self.navigationController?.popViewController(animated: true)

        } else {
            let alertController = UIAlertController(title: "No date selected", message: "Please select a date before adding it to your event", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //do nothing
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
