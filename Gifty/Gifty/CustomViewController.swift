//
//  CustomViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Default"
        //titleLabel.font = FontManager.AvenirNextRegular(size: FontManager.sizeNavText)
        return titleLabel
    }()
    
    func setTitleLabelPosition(withSize size: CGSize) {
        var labelX: CGFloat = -13.0
        var labelY: CGFloat = 10
        
        if UIDevice.current.orientation.isPortrait {
            labelX += size.width / 8
            labelY += 20
        } else {
            labelX += size.height / 8
        }
        self.titleLabel.frame = CGRect(x: labelX, y: labelY, width: 250, height: 25)
    }
    
    var backgroundView: BackgroundGradient!
    
    //MARK: turn off autorotate
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return [.portrait, .landscape]
    }
    

 
}
