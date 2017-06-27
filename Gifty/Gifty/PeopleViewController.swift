//
//  PeopleViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class PeopleViewController: CustomViewController {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.blue
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "People"
        self.setTitleLabelPosition(withSize: view.bounds.size)
        
        setupCollectionView()
        
    }

    private func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PeopleCell.self, forCellWithReuseIdentifier: "PeopleCell")
        
        view.addSubview(collectionView)
        
        if let navHeight = navigationController?.navigationBar.frame.height {
            let yVal = navHeight + UIApplication.shared.statusBarFrame.height
            collectionView.frame = CGRect(x: 0, y: yVal, width: self.view.bounds.width, height: self.view.bounds.height - yVal)
        }
    }

    //MARK: orientation change methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.setTitleLabelPosition(withSize: size)
    }
    
}

extension PeopleViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCell", for: indexPath)
        return  cell
    }
    
}
