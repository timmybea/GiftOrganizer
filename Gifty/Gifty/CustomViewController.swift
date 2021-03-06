//
//  CustomViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class CustomViewController: UIViewController {
    
    override func viewDidLoad() {
        tabBarController?.delegate = self
        
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
    
    lazy var navHeight: CGFloat = {
        return navigationController?.navigationBar.frame.height ?? 0.0
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
        
        imageView.image =  UIImage(named: ImageNames.verticalBGGradient.rawValue)
        
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

extension CustomViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        UITabBarController.currentIndex = tabBarController.selectedIndex        
    }
}

