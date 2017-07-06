//
//  PersonCell.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-06.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    let whiteView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: CircleView = {
        let view = CircleView(image: UIImage(named: ImageNames.defaultProfileBlock.rawValue))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.highlightedText
        label.font = FontManager.subtitleText
        return label
    }()
    
    let eventIcon: UIImageView = {
        let image = UIImage(named: ImageNames.eventIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.tintColor = ColorManager.highlightedText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let eventCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.highlightedText
        label.textAlignment = .left
        label.font = FontManager.subtitleText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/0"
        return label
    }()
    
    let budgetSummaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.highlightedText
        label.textAlignment = .left
        label.font = FontManager.smallText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total budget: $0, Spent: $0"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func setupViews() {
        self.backgroundColor = UIColor.clear
        
        self.selectionStyle = .none
        
        let medPad: CGFloat = 8
        let smallPad: CGFloat = 4
        
        self.addSubview(whiteView)
        whiteView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        whiteView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        whiteView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        
        self.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: whiteView.leftAnchor, constant: medPad).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor).isActive = true
//        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
//        profileImageView.layer.masksToBounds = true
        
        self.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: medPad).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        
        
        self.addSubview(eventCountLabel)
        eventCountLabel.leftAnchor.constraint(equalTo: whiteView.rightAnchor, constant: -40).isActive = true
        eventCountLabel.rightAnchor.constraint(equalTo: whiteView.rightAnchor, constant: -medPad).isActive = true
        eventCountLabel.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor).isActive = true

        self.addSubview(eventIcon)
        eventIcon.rightAnchor.constraint(equalTo: eventCountLabel.leftAnchor, constant: -smallPad).isActive = true
        eventIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        eventIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eventIcon.centerYAnchor.constraint(equalTo: whiteView.centerYAnchor).isActive = true
        
        self.addSubview(budgetSummaryLabel)
        budgetSummaryLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: medPad).isActive = true
        budgetSummaryLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        
    }
    
    func configureCellWith(person: Person) {
        nameLabel.text = person.fullName
        
        if let imageData = person.profileImage {
            let image = UIImage(data: imageData as Data)
            profileImageView.image = image
        }
    }
}
