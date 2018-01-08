//
//  CustomViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    override func viewDidLoad() {
        setupBackgroundView()
    }
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = Theme.fonts.titleText.font
        return titleLabel
    }()
    
    func setTitleLabelPosition(withSize size: CGSize) {

        var labelX: CGFloat = -20.0
        var labelY: CGFloat = 10
        
        if UIDevice.current.orientation.isPortrait {
            labelX += size.width / 8
            labelY += 20
        } else {
            labelX += size.height / 8
        }
        
        self.titleLabel.frame = CGRect(x: labelX, y: labelY, width: 200, height: 28)
    }
    
    var backgroundView: UIImageView!
    
    func setupBackgroundView() {
        
        let imageView = UIImageView()
        imageView.image =  UIDevice.current.orientation.isPortrait ? UIImage(named: ImageNames.verticalBGGradient.rawValue) : UIImage(named: ImageNames.horizontalBGGradient.rawValue)
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundView = imageView
        view.addSubview(self.backgroundView)
        
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}
