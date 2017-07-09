//
//  SearchHeaderView.swift
//  Gifty
//
//  Created by Tim Beals on 2017-07-07.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class SearchHeaderView: UIView {

    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["by Name", "by Group"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.white
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.isTranslucent = true
        let image = UIImage()
        searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        searchBar.scopeBarBackgroundImage = image
        searchBar.barTintColor = UIColor.clear
        searchBar.returnKeyType = .done
        searchBar.tintColor = UIColor.white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        backgroundColor = UIColor.clear
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubviews() {
        
        addSubview(searchBar)
        searchBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        searchBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        
        addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: pad).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -pad).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -6).isActive = true
    }
}
