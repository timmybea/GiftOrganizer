//
//  PeopleViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import CoreData

class PeopleViewController: CustomViewController {
    
    var frc: NSFetchedResultsController<Person>? = PersonFRC.frc
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        self.titleLabel.isHidden = false
    }
    
    private func setupNavigationBar() {
        self.titleLabel.text = "People"
        self.setTitleLabelPosition(withSize: view.bounds.size)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToCreatePerson))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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

    func pushToCreatePerson() {
     
        self.titleLabel.isHidden = true
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(CreatePersonViewController(), animated: true)
        }
    }
    
    //MARK: orientation change methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.setTitleLabelPosition(withSize: size)
    }
    
}

extension PeopleViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return frc?.sections?.count ?? 0
    }
    
    
    //Section Titles 
//    func indexTitles(for collectionView: UICollectionView) -> [String]? {
//        //???? IS THIS CORRECT??
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = frc?.sections?[section]
        return (sectionInfo?.numberOfObjects)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCell", for: indexPath) as? PeopleCell
        if let person = frc?.object(at: indexPath) {
            cell?.configureCellWith(person: person)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //update person
        pushToCreatePerson()
    }
}
