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
    
    var frc: NSFetchedResultsController<Person>? = PersonFRC.frc(byGroup: true)
    var isSortByGroup = true
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.clear
        tableview.separatorColor = UIColor.clear
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(PersonCell.self, forCellReuseIdentifier: "PersonCell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc?.delegate = self
        setupNavigationBar()
        setupTableView()
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

    private func setupTableView() {
        
        view.addSubview(tableView)
        
        if let navHeight = navigationController?.navigationBar.frame.height , let tabHeight = tabBarController?.tabBar.frame.height {
            let yVal = navHeight + UIApplication.shared.statusBarFrame.height
            tableView.frame = CGRect(x: 0, y: yVal, width: self.view.bounds.width, height: self.view.bounds.height - yVal - tabHeight)
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


extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (frc?.sections?.count)!
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if isSortByGroup {
//            let sectionInfo = frc?.sections?[section]
//            return sectionInfo?.name
//        } else {
//            return nil
//        }
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if isSortByGroup {
            let sectionInfo = frc?.sections?[section]
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = ColorManager.highlightedText
            
            let label = UILabel(frame: CGRect(x: pad, y: 8, width: 200, height: 20))
            label.font = FontManager.subtitleText
            label.textColor = UIColor.white
            label.text = sectionInfo?.name
            backgroundView.addSubview(label)

//            backgroundView.layer.shadowRadius = 2
//            backgroundView.layer.shadowColor = UIColor.black as! CGColor

            
            return backgroundView
            
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = frc?.sections?[section]
        return (sectionInfo?.numberOfObjects)!
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as? PersonCell
        if let person = frc?.object(at: indexPath) {
            cell?.configureCellWith(person: person)
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToCreatePerson()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
}

extension PeopleViewController: NSFetchedResultsControllerDelegate {
  
    //MARK: Fetched results controller - Update tableview with changed from detailvc
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            let cell = tableView.cellForRow(at: indexPath!) as? PersonCell
            let person = anObject as! Person
            cell?.configureCellWith(person: person)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       self.tableView.endUpdates()
    }

}
