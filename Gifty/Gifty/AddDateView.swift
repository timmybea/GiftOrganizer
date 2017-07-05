//
//  addDate.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-05.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol AddDateViewDelegate {
    func addDateViewWasTouched()
}

class AddDateView: UIControl{

    let label: UILabel = {
        let label = UILabel()
        label.text = "Select date"
        label.textColor = UIColor.white
        label.font = FontManager.mediumText
        label.textAlignment = .left
        return label
    }()
    
    let calendarImage: UIImageView = {
        let image = UIImage(named: ImageNames.calendarIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var delegate: AddDateViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViews()
        
        self.addTarget(self, action: #selector(didTouchDownSelf), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchUpSelf), for: .touchUpInside)
    }
    
    func layoutViews() {
        calendarImage.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
        self.addSubview(calendarImage)
        
        label.frame = CGRect(x: self.bounds.height + pad, y: self.bounds.height - 18, width: self.bounds.width - self.bounds.height - pad, height: 18)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel(string: String) {
        self.label.text = string
    }
    
    
    func didTouchDownSelf() {
    
        self.calendarImage.tintColor = ColorManager.lightText
        self.label.textColor = ColorManager.lightText
    }
    
    func didTouchUpSelf() {
        self.calendarImage.tintColor = UIColor.white
        self.label.textColor = UIColor.white
    
        if self.delegate != nil {
            self.delegate?.addDateViewWasTouched()
        }
    }
    
}
