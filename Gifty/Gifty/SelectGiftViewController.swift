//
//  SelectGiftViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-03-20.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

protocol SelectGiftVCDelegate {
    func selectedGift(_ gift: Gift)
}

class SelectGiftViewController: CustomViewController {
   
    var delegate: SelectGiftVCDelegate?
    
    var giftEventCache: GiftEventCache?
    
    var person: Person? = nil {
        didSet {
            getDataSource()
        }
    }
    
    var dataSource: [Gift]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Available", "Assigned"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.bounces = false
        tv.backgroundColor = UIColor.clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(GiftSelectTableViewCell.self, forCellReuseIdentifier: "giftSelectCell")
        return tv
    }()
    
    var tvHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Gift"
        
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTouched(sender:)))
        
        self.navigationItem.leftBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched))
        navigationItem.rightBarButtonItem = addButton
        
        
        
        setupSubviews()
    }
    
    private func getDataSource() {
        guard let p = self.person else { return }
        guard let gifts = p.gift?.allObjects as? [Gift] else { return }
        
        let currentData : [Gift]
        
        if segmentedControl.selectedSegmentIndex == 0 {
            currentData = gifts.filter() { $0.eventId == nil || $0.eventId == "" }
            let orderedData = currentData.sorted() { $0.name! < $1.name! }
            self.dataSource = orderedData
        } else {
            currentData = gifts.filter() { $0.eventId != nil && $0.eventId != "" }            
            GiftEventCache.loadCache(for: currentData, completion: {
                let orderedIds = GiftEventCache.returnOrderedGiftIds()
                var orderedEvents = [Gift]()
                idLoop: for id in orderedIds {
                    giftLoop: for gift in currentData {
                        if gift.eventId == id {
                            orderedEvents.append(gift)
                            break giftLoop
                        }
                    }
                }
                self.dataSource = orderedEvents
            })
        }
        setTableViewHeight()
    }
    
    private func setupSubviews() {
        
        view.addSubview(segmentedControl)
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let xPad = isPad ? view.bounds.width / 4 : pad
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaTop + navHeight + pad),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: xPad),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -xPad)
            ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: pad),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        tvHeightConstraint = NSLayoutConstraint(item: tableView,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: tableView,
                                                attribute: .height,
                                                multiplier: 0, constant: 0)
        tvHeightConstraint.isActive = true
        tableView.addConstraint(tvHeightConstraint)
        
        self.getDataSource()
    }
    
    private func setTableViewHeight() {
        guard tvHeightConstraint != nil else { return }
        let dataCount = dataSource == nil ? 0 : dataSource!.count
        tvHeightConstraint.constant = CGFloat(dataCount) * GiftSelectTableViewCell.cellHeight
    }
    
    @objc
    func backButtonTouched(sender: UIButton) {
        
        print("Back button touched")
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func addButtonTouched() {
        let dest = CreateGiftViewController()
        if let p = self.person {
            dest.setupNewGiftFor(person: p)
            dest.delegate = self
        }
        navigationController?.pushViewController(dest, animated: true)
    }

}


extension SelectGiftViewController: CreateGiftViewControllerDelegate {
    
    func newGiftCreated() {
        if segmentedControl.selectedSegmentIndex == 0 {
            getDataSource()
        }
    }
}

//MARK: Table View delegate and datasource
extension SelectGiftViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "giftSelectCell") as! GiftSelectTableViewCell
        guard let gift = dataSource?[indexPath.row] else { return cell }
        cell.setup(with: gift)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! GiftSelectTableViewCell
            let gift = cell.gift!
            
            self.delegate?.selectedGift(gift)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GiftSelectTableViewCell.cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            //remove from data source and table
            tableView.beginUpdates()
            if let gift = self.dataSource?.remove(at: indexPath.row) {
                gift.managedObjectContext?.delete(gift)
                ManagedObjectBuilder.saveChanges(dataPersistence: DataPersistenceService.shared, completion: {(success) in
                    //do nothing
                })
                
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            self.setTableViewHeight()
        }
        deleteAction.backgroundColor = Theme.colors.lightToneTwo.color
        
        let viewEditAction = UITableViewRowAction(style: .default, title: "View/Edit") { (action, indexPath) in
            if let gift = self.dataSource?[indexPath.row] {
                let dest = CreateGiftViewController()
                dest.setupForEditMode(with: gift)
                self.navigationController?.pushViewController(dest, animated: true)
            }
        }
        viewEditAction.backgroundColor = Theme.colors.lightToneOne.color
        
        return segmentedControl.selectedSegmentIndex == 0 ? [deleteAction, viewEditAction] : [viewEditAction]
    }
    
    //only able to delete gift if it is unassigned
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: Segmented Control method

extension SelectGiftViewController {
    
    @objc
    func segmentedControlValueChanged(sender: UISegmentedControl) {
        getDataSource()
    }
}
