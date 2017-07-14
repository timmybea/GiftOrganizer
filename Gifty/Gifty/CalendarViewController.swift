//
//  CalendarViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarViewController: CustomViewController {
    
    var calendar: CustomCalendar!
    
    var whiteDisplayView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: ImageNames.calendarDisplayView.rawValue)
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCustomCalendar()
        setupWhiteDisplayView()
        
        let timer = ScheduledTimer()
        timer.delegate = self
    }
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToCreateEvent))
    }
    
    fileprivate func setupCustomCalendar() {
        if calendar != nil {
            calendar.removeFromSuperview()
            calendar = nil
        }
        
        let frame = CGRect(x: pad, y: 70, width: self.view.bounds.width - (2 * pad), height: 280)
        calendar = CustomCalendar(frame: frame)
        calendar.delegate = self
        view.addSubview(calendar)
    }
    
    private func setupWhiteDisplayView() {
        let frame = CGRect(x: -20, y: self.view.bounds.height * 0.62, width: self.view.bounds.width + 40, height: self.view.bounds.height + 60)
        whiteDisplayView.frame = frame
        view.addSubview(whiteDisplayView)
    }
    
    func pushToCreateEvent() {
        print("push to create event")
    }

    //MARK: orientation change methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
}

extension CalendarViewController: CustomCalendarDelegate {
    
    func monthYearLabelWasUpdated(_ string: String) {
        self.title = string
    }

    
    func hideShowInfoForSelectedDate(_ date: Date, show: Bool) {
        if show {
            print(date)
        } else {
            print("Don't show info")
        }
    }
}

extension CalendarViewController: SchedultedTimerDelegate {
    
    func executeAtMidnight() {
        setupCustomCalendar()
    }
}


