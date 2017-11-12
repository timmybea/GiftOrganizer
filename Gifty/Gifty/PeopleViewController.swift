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
    
    var frc: NSFetchedResultsController<Person>? = PersonFRC.frc(byGroup: false)
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: UITableViewStyle.grouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = UIColor.clear
        tableview.separatorColor = UIColor.clear
        tableview.showsVerticalScrollIndicator = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(PersonCell.self, forCellReuseIdentifier: "PersonCell")
        return tableview
    }()
    
    let headerView: SearchHeaderView = {
        let view = SearchHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var headerViewHeightConstraint: NSLayoutConstraint!
    let maxHeaderHeight: CGFloat = 100
    let minHeaderHeight: CGFloat = 0
    
    var previousScrollOffset: CGFloat = 0
    
    var isSearching = false
    var filteredData = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.searchBar.delegate = self
        headerView.segmentedControl.addTarget(self, action: #selector(didChangeSortBy), for: .valueChanged)
        
        frc?.delegate = self
        setupNavigationBar()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.titleLabel.isHidden = false
        
        headerViewHeightConstraint.constant = maxHeaderHeight
        updateHeader()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.title = "People"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched))
    }

    private func setupSubviews() {
                
        let navHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        let tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        
        view.addSubview(headerView)
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: navHeight).isActive = true
        headerViewHeightConstraint = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: headerView, attribute: .height, multiplier: 0, constant: 0)
        headerViewHeightConstraint.isActive = true
        headerView.addConstraint(headerViewHeightConstraint)
        
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight).isActive = true
    }
    
    @objc func addButtonTouched() {
        pushToCreatePerson(person: nil)
    }

    func pushToCreatePerson(person: Person?) {
        self.titleLabel.isHidden = true
        
        let destination = CreatePersonViewController()
        destination.delegate = self

        if person != nil {
            destination.person = person
            destination.isUpdatePerson = true
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    //MARK: segmented Controller
    @objc func didChangeSortBy(sender: UISegmentedControl) {
        self.frc = nil
        if sender.selectedSegmentIndex == 0 {
            self.frc = PersonFRC.frc(byGroup: false)
        } else {
            self.frc = PersonFRC.frc(byGroup: true)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: orientation change method
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.setTitleLabelPosition(withSize: size)
    }
}


extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return (frc?.sections?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching {
            return nil
        } else {
            let sectionInfo = frc?.sections?[section]

            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear

            let label = UILabel(frame: CGRect(x: pad, y: 8, width: 200, height: 20))
            label.font = Theme.fonts.subtitleText.font
            label.textColor = UIColor.white
            label.text = sectionInfo?.name
            backgroundView.addSubview(label)

            return backgroundView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredData.count
        } else {
            let sectionInfo = frc?.sections?[section]
            return (sectionInfo?.numberOfObjects)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as? PersonCell
        
        var person: Person
        if isSearching {
            person = filteredData[indexPath.row]
        } else {
            person = (frc?.object(at: indexPath))!
        }
        cell?.configureCellWith(person: person)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PersonCell
        if let person = cell.person {
            pushToCreatePerson(person: person)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching {
            return 0
        } else {
           return 34
        }
    }
    
    //MARK: Editing methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            var person: Person
            if self.isSearching {
                person = self.filteredData[indexPath.row]
            } else {
                person = (self.frc?.object(at: indexPath))!
            }
            
            for event in person.event?.allObjects as! [Event] {
                
                guard let dateString = event.dateString else { return }
                
                event.managedObjectContext?.delete(event)
                
                let notificationDispatch = DispatchQueue(label: "notificationQueue", qos: DispatchQoS.userInitiated)
                
                notificationDispatch.async {
                    let userInfo = ["EventDisplayViewId": "none", "dateString": dateString]
                    NotificationCenter.default.post(name: Notifications.names.eventDeleted.name, object: nil, userInfo: userInfo)
                }
            }
            
            person.managedObjectContext?.delete(person)
            
            ManagedObjectBuilder.saveChanges(completion: { (success) in
                print("Deleted person and their events and saved changes.")
            })
        }
        deleteAction.backgroundColor = Theme.colors.lightToneTwo.color
        return [deleteAction]
    }
}

extension PeopleViewController {
    
    //MARK: Animated header methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            var newHeight = headerViewHeightConstraint.constant
            
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerViewHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp && scrollView.contentOffset.y <= 0 {
                newHeight = min(self.maxHeaderHeight, self.headerViewHeightConstraint.constant + abs(scrollDiff))
            }
            
            if newHeight != self.headerViewHeightConstraint.constant {
                self.headerViewHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(position: self.previousScrollOffset)
            }
        }
        self.previousScrollOffset = scrollView.contentOffset.y
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + headerViewHeightConstraint.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func setScrollPosition(position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerViewHeightConstraint.constant > midPoint {
            expandHeader()
        } else {
            collapseHeader()
        }
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerViewHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerViewHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerViewHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        headerView.segmentedControl.alpha = percentage
        headerView.searchBar.alpha = percentage
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


extension PeopleViewController: UISearchBarDelegate {
    //MARK: SearchBar Delegate Methods
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
        } else {
            isSearching = true
            
            let filterResult = frc?.fetchedObjects?.filter({ (person) -> Bool in
                person.fullName!.localizedCaseInsensitiveContains(searchBar.text!)
            })
            if filterResult != nil {
                filteredData = filterResult!
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.delegate?.searchBar!(searchBar, textDidChange: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
}

extension PeopleViewController: CreatePersonViewControllerDelegate {
    
    func didSaveChanges() {
        
        do {
            try frc?.performFetch()
        } catch {
            print("uh oh")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
