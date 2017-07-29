//
//  WhiteDisplayView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-28.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

protocol WhiteDisplayViewDelegate {
    func whiteDisplayPosition(up: Bool)
}

class WhiteDisplayView: UIView {

    var delegate: WhiteDisplayViewDelegate?
    
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

    
    private func setupSubviews() {
        
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
        
        
    }
    
    func whiteDisplaySnapped() {
        
        UIView.animate(withDuration: 0.2) { 
            self.swipeIcon.transform = self.swipeIcon.transform.rotated(by: CGFloat.pi)
        }
        
        isSnapped = true
        
        if self.delegate != nil {
            self.delegate?.whiteDisplayPosition(up: true)
        }
    }
    
    func whiteDisplayTouchedBoundary() {
        if isSnapped == true {
            whiteDisplayDown()
            isSnapped = false
        }
        
    }
    
    private func whiteDisplayDown() {

        UIView.animate(withDuration: 0.2) {
            self.swipeIcon.transform = self.swipeIcon.transform.rotated(by: CGFloat.pi)
        }
        
        if self.delegate != nil {
            self.delegate?.whiteDisplayPosition(up: false)
        }
    }
}
