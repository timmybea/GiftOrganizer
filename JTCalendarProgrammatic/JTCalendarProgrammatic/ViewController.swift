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
    
    var bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "background_gradient")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var whiteDisplayView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "cal_display_view")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgImageView)
        bgImageView.frame = self.view.bounds
        
        setupCustomCalendar()
        setupWhiteDisplayView()
    }
    
    let pad: CGFloat = 8
    
    private func setupCustomCalendar() {
        let frame = CGRect(x: pad, y: 50, width: self.view.bounds.width - (2 * pad), height: 320)
        calendar = CustomCalendar(frame: frame)
        calendar.delegate = self
        view.addSubview(calendar)
    }
    
    private func setupWhiteDisplayView() {
        let frame = CGRect(x: -20, y: self.view.bounds.height * 0.62, width: self.view.bounds.width + 40, height: self.view.bounds.height + 60)
        whiteDisplayView.frame = frame
        view.addSubview(whiteDisplayView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CustomCalendarDelegate {
    
    func dateWasSelected(_ date: Date) {
        print(date.description)
    }
    
    
    
    
}

