//
//  AddGiftView.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-19.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

protocol AddGiftViewDelegate {
    func addGiftViewWasTouched()
}

class AddGiftView: UIView {
    
    static var height: CGFloat {
        return 25.0 + (CGFloat(30 * giftCount))
    }
    
    static var headerHeight: CGFloat = 25.0
    
    static var giftCount = 0
    
    let touchView: UIControl = {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Gift"
        label.textColor = UIColor.white
        label.font = Theme.fonts.boldSubtitleText.font
        label.textAlignment = .left
        return label
    }()
    
    let giftImage: UIImageView = {
        let image = UIImage(named: ImageNames.gift.rawValue)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let underline: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    }()
    
    var delegate: AddGiftViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViews()
        
        touchView.addTarget(self, action: #selector(didTouchDownSelf), for: .touchDown)
        touchView.addTarget(self, action: #selector(didTouchUpSelf), for: .touchUpInside)
    }
    
    func layoutViews() {
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        self.addSubview(underline)
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            underline.leftAnchor.constraint(equalTo: self.leftAnchor),
            underline.rightAnchor.constraint(equalTo: self.rightAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2)
            ])
        
        self.addSubview(giftImage)
        NSLayoutConstraint.activate([
            giftImage.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            giftImage.rightAnchor.constraint(equalTo: label.leftAnchor, constant: -pad),
            giftImage.heightAnchor.constraint(equalToConstant: 18),
            giftImage.widthAnchor.constraint(equalToConstant: 18),
            ])
        
        self.addSubview(touchView)
        bringSubview(toFront: touchView)
        NSLayoutConstraint.activate([
            touchView.leftAnchor.constraint(equalTo: self.leftAnchor),
            touchView.rightAnchor.constraint(equalTo: self.rightAnchor),
            touchView.topAnchor.constraint(equalTo: self.topAnchor),
            touchView.heightAnchor.constraint(equalToConstant: AddGiftView.headerHeight)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: touchViewtouched (protocol method called)
extension AddGiftView {
    
    @objc func didTouchDownSelf() {
        //print("touch down")
        
        
        self.giftImage.tintColor = Theme.colors.lightToneOne.color
        self.label.textColor = Theme.colors.lightToneOne.color
        self.underline.backgroundColor = Theme.colors.lightToneOne.color
    }
    
    @objc func didTouchUpSelf() {
        //print("touch up")
        
        self.giftImage.tintColor = UIColor.white
        self.label.textColor = UIColor.white
        self.underline.backgroundColor = UIColor.white
        
        if self.delegate != nil {
            self.delegate?.addGiftViewWasTouched()
        }
    }
}
