//
//  DateCETableViewCell.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-08.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol CENDateTableViewCellDelegate {
    func setNotificationDate(_ date: Date)
}

class CENDateTableViewCell: UITableViewCell {
    
    //You could have this adjustable in settings.
    enum Time {
        case am
        case pm
        
        var dateComponent: Int {
            switch self {
            case .am: return 8
            case .pm: return 14
            }
        }
        
        var text: String {
            switch self {
            case .am: return "AM"
            case .pm: return "PM"
            }
        }
    }
    
    private var date: Date? {
        didSet {
            if let d = getDateAndTime() {
                self.delegate?.setNotificationDate(d)
            }
        }
    }
    
    private var time: Time = .am {
        didSet {
            if let d = getDateAndTime() {
                self.delegate?.setNotificationDate(d)
            }
        }
    }
    
    var delegate: CENDateTableViewCellDelegate?
    
    let calendarImage: UIImageView = {
        let image = UIImage(named: ImageNames.calendarIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Theme.colors.lightToneTwo.color
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select date"
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = Theme.fonts.mediumText.font
        label.textAlignment = .left
        return label
    }()
    
    let ampmSwitch: UISwitch = {
        let newSwitch = UISwitch()
        newSwitch.setOn(false, animated: false)
        newSwitch.translatesAutoresizingMaskIntoConstraints = false
        newSwitch.onTintColor = Theme.colors.lightToneOne.color
        newSwitch.tintColor = Theme.colors.lightToneTwo.color
        return newSwitch
    }()
    
    let ampmLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.colors.lightToneTwo.color
        label.font = Theme.fonts.mediumText.font
        label.textAlignment = .right
        label.text = Time.am.text
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        setupSubviews()
        
        ampmSwitch.addTarget(self, action: #selector(ampmSwitchChanged(sender:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

    func setupSubviews() {
        
        addSubview(calendarImage)
        NSLayoutConstraint.activate([
            calendarImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad),
            calendarImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -smallPad),
            calendarImage.heightAnchor.constraint(equalToConstant: 25),
            calendarImage.widthAnchor.constraint(equalToConstant: 25)
            ])
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: calendarImage.rightAnchor, constant: pad),
            label.centerYAnchor.constraint(equalTo: calendarImage.centerYAnchor)
            ])
        
        addSubview(ampmSwitch)
        NSLayoutConstraint.activate([
            ampmSwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad),
            ampmSwitch.centerYAnchor.constraint(equalTo: calendarImage.centerYAnchor)
            ])
        
        addSubview(ampmLabel)
        NSLayoutConstraint.activate([
            ampmLabel.rightAnchor.constraint(equalTo: ampmSwitch.leftAnchor, constant: -smallPad),
            ampmLabel.centerYAnchor.constraint(equalTo: calendarImage.centerYAnchor)
            ])
    }
    
    func update(with date: Date?) {
        if date != nil {
            self.label.text = DateHandler.describeDate(date!)
            self.date = date
        } else {
            self.label.text = "Select date"
        }
    }
    
    func getDateAndTime() -> Date? {
        
        guard let d = self.date else { return nil }
        //"yyyy MM dd"
        let dateComponents = DateHandler.stringFromDate(d).components(separatedBy: " ")
        
        guard dateComponents.count == 3 else { return nil }
        let yyyy = Int(dateComponents[0])
        let mm = Int(dateComponents[1])
        let dd = Int(dateComponents[2])
        
        let hr = time.dateComponent
        
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.year = yyyy
        components.month = mm
        components.day = dd
        components.hour = hr
        
        return calendar.date(from: components)
    }
    
    @objc
    func ampmSwitchChanged(sender: UISwitch) {
        self.time = sender.isOn ? .pm : .am
        ampmLabel.text = self.time.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        calendarImage.tintColor = highlighted ? Theme.colors.lightToneOne.color : Theme.colors.lightToneTwo.color
        label.textColor = highlighted ? Theme.colors.lightToneOne.color : Theme.colors.lightToneTwo.color
    }
}
