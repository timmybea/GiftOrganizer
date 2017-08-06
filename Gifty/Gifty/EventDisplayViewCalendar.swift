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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func setupSubviews() {
        
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
        
//        addSubview(eventLabel)
//        eventLabel.leftAnchor.constraint(equalTo: tableView.leftAnchor).isActive  = true
//        eventLabel.bottomAnchor.constraint(equalTo: addButton.bottomAnchor).isActive = true
        
    }
    
    var heightConstraintTableView: NSLayoutConstraint?
    var tableViewMaxY: CGFloat = 0.0
    var heightDown: CGFloat = 0.0
    var heightUp: CGFloat = 0.0
    
    func setTableViewFrame(with maxY: CGFloat) {
        self.tableViewMaxY = maxY
        self.heightDown = self.tableViewMaxY - self.frame.minY - smallPad - 34
        self.heightUp = 500
            
        addSubview(tableView)
        //tableView.backgroundColor = UIColor.blue
        tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: smallPad).isActive = true
        self.heightConstraintTableView = tableView.heightAnchor.constraint(equalToConstant: heightDown)
        self.heightConstraintTableView?.isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    func eventDisplaySnapped() {
        
        isSnapped = true
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
            self.swipeIcon.transform = self.swipeIcon.transform.rotated(by: CGFloat.pi)
            
            self.heightConstraintTableView?.constant = self.heightUp
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
            
            self.heightConstraintTableView?.constant = self.heightDown
            self.tableView.layoutIfNeeded()
        }, completion: nil)
        
        if self.stackViewDelegate != nil {
            self.stackViewDelegate?.eventDisplayPosition(up: false)
        }
    }
}
