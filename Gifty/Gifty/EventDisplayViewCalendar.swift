//
//  WhiteDisplayView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol StackViewDelegate {
    func eventDisplayPosition(up: Bool)
    func stackViewPan(panRecognizer: UIPanGestureRecognizer)
}

class EventDisplayViewCalendar: EventTableView {

    var stackViewDelegate: StackViewDelegate?
    
    var isSnapped = false
        
    let swipeIcon: UIImageView = {
        let swipeIcon = UIImage(named: ImageNames.swipeIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: swipeIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Theme.colors.lightToneTwo.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.colors.lightToneOne.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let panGestureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(frame: CGRect, in superView: UIView) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.colors.offWhite.color
        
        setupSubviews(in: superView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func currentlyDisplaying(dateString: String) -> Bool {
        
        if let currentDate = self.displayDateString {
            return currentDate == dateString
        } else {
            return false
        }
    }
    
    
    func setupSubviews(in superView: UIView) {
        
        self.addSubview(swipeIcon)
        swipeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        swipeIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        swipeIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        swipeIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        swipeIcon.transform = swipeIcon.transform.rotated(by: CGFloat.pi)
        
        self.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.addSubview(panGestureView)
        panGestureView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        panGestureView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        panGestureView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        panGestureView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        
        //pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panRecognizer:)))
        panGestureView.addGestureRecognizer(panGesture)
        
    }
    
    //MARK: setup pan
    func handlePan(panRecognizer: UIPanGestureRecognizer) {
        
        if stackViewDelegate != nil {
            stackViewDelegate?.stackViewPan(panRecognizer: panRecognizer)
        }

    }
    
    var heightConstraintTableView: NSLayoutConstraint?
    var heightDown: CGFloat = 0.0
    var heightUp: CGFloat = 0.0
    
    func setTableViewFrame(with tabHeight: CGFloat, navHeight: CGFloat) {
        
        self.heightDown = self.frame.height - self.frame.minY - smallPad - 34 - tabHeight
        self.heightUp = self.frame.height - smallPad - 34 - tabHeight - pad - navHeight
            
        addSubview(tableView)
        tableView.frame = CGRect(x: pad, y: 34, width: self.frame.width - pad, height: heightDown)
    }
    
    func eventDisplaySnapped() {
        
        isSnapped = true
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
            self.swipeIcon.transform = self.swipeIcon.transform.rotated(by: CGFloat.pi)
            
            self.tableView.frame = CGRect(x: pad, y: 34, width: self.frame.width - pad, height: self.heightUp)
            self.tableView.layoutIfNeeded()
        }, completion: nil)
        
        if self.stackViewDelegate != nil {
            self.stackViewDelegate?.eventDisplayPosition(up: true)
        }
    }
    
    func eventDisplayTouchedBoundary() {
        if isSnapped == true {
            isSnapped = false
            eventDisplayDown()
        }
    }
    
    private func eventDisplayDown() {

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.swipeIcon.transform = self.swipeIcon.transform.rotated(by: CGFloat.pi)
            
            self.tableView.frame = CGRect(x: pad, y: 34, width: self.frame.width - pad, height: self.heightDown)
            self.tableView.layoutIfNeeded()
        }, completion: nil)
        
        if self.stackViewDelegate != nil {
            self.stackViewDelegate?.eventDisplayPosition(up: false)
        }
    }
}
