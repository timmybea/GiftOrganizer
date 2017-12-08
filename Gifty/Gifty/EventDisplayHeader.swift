//
//  EventDisplayHeader.swift
//  Gifty
//
//  Created by Tim Beals on 2017-09-07.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol EventDisplayViewHeaderDelegate {
    func segControlChanged(to index: Int)
}

class EventDisplayHeader: UIView {
    
    var delegate: EventDisplayViewHeaderDelegate?

    private var frameWidth: CGFloat = 0.0
    private let maxHeaderHeight: CGFloat = 44
    private let minHeaderHeight: CGFloat = 0
    
    private var rectForHeaderAppear: CGRect {
        return CGRect(x: 0, y: 0, width: frameWidth, height: maxHeaderHeight)
    }
    
    private var rectForHeaderDisappear: CGRect {
        return CGRect(x: 0, y: 0, width: frameWidth, height: minHeaderHeight)
    }
    
    enum SegmentIndex: Int {
        case upcomingEvents = 0, overdueEvents, budgetChart
        var title: String {
            switch self {
            case .upcomingEvents: return "Upcoming"
            case .overdueEvents: return "Overdue"
            case .budgetChart: return "Spending"
            }
        }
    }
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [SegmentIndex.upcomingEvents.title,
                                                          SegmentIndex.overdueEvents.title,
                                                          SegmentIndex.budgetChart.title])
        segmentedControl.selectedSegmentIndex = SegmentIndex.upcomingEvents.rawValue
        segmentedControl.tintColor = Theme.colors.lightToneTwo.color
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    
    convenience init(with width: CGFloat) {
        self.init()
        self.backgroundColor = UIColor.clear
        setup(with: width)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(with width: CGFloat) {
        
        self.frameWidth = width
        self.frame = self.rectForHeaderAppear
        addSegmentedControl()
        self.frame = self.rectForHeaderDisappear
    }
    
    private func addSegmentedControl() {
        
        addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: smallPad).isActive = true
        segmentedControl.isHidden = true
        
        segmentedControl.addTarget(self, action: #selector(segmentedControllerChanged(sender:)), for: .valueChanged)
    }
    
    func setFrame(appear: Bool) {
        self.frame = appear ? self.rectForHeaderAppear : self.rectForHeaderDisappear
    }
    
    func headerAppearAnimation() {
        segmentedControl.alpha = 0
        segmentedControl.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.segmentedControl.alpha = 100
        }, completion: nil)
    }
    
    func headerDisappearAnimation(completion: @escaping (_ success: Bool) -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.segmentedControl.alpha = 0
        }, completion: { (success) in
            self.segmentedControl.isHidden = true
            completion(true)
        })
    }
    
    func resetSegControl() {
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc
    private func segmentedControllerChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if let title = sender.titleForSegment(at: index) {
            self.delegate?.segControlChanged(to: index)
        }
    }
}
