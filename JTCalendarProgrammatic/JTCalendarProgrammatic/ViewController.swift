//
//  ViewController.swift
//  JTCalendarProgrammatic
//
//  Created by Tim Beals on 2017-06-20.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {

    var calendar: CustomCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.brown
        
        setupCustomCalendar()
    }
    
    private func setupCustomCalendar() {
        
        let frame = CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 360)
        calendar = CustomCalendar(frame: frame)
        view.addSubview(calendar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

