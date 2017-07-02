//
//  EventCollectionView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol EventCollectionViewDelegate {
    func didTouchAddEventButton()
}

class EventCollectionView: UIView {

    var delegate: EventCollectionViewDelegate?
    
    var eventLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorManager.highlightedText
        label.text = "No events created"
        label.textAlignment = .left
        label.font = FontManager.subtitleText
        return label
    }()
    
    lazy var addButton: CustomImageControl = {
        let add = CustomImageControl()
        add.imageView.image = UIImage(named: ImageNames.addButton.rawValue)?.withRenderingMode(.alwaysTemplate)
        add.imageView.contentMode = .scaleAspectFill
        add.imageView.tintColor = ColorManager.highlightedText
        add.addTarget(self, action: #selector(addButtonTouchedDown), for: .touchDown)
        add.addTarget(self, action: #selector(addButtonTouchedUpInside), for: .touchUpInside)
        return add
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        backgroundColor = UIColor.white
        self.layer.cornerRadius = 5

        addSubview(addButton)
        let addSize: CGFloat = 30
        addButton.frame = CGRect(x: self.bounds.width - 4 - addSize, y: 4, width: addSize, height: addSize)
        
        addSubview(eventLabel)
        eventLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        eventLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

extension EventCollectionView {
    
    func addButtonTouchedDown() {
        addButton.imageView.tintColor = ColorManager.lightText
    }
    
    func addButtonTouchedUpInside() {
        addButton.imageView.tintColor = ColorManager.highlightedText
        if self.delegate != nil {
            self.delegate?.didTouchAddEventButton()
        }
    }
}
