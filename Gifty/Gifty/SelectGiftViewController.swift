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
    
    lazy var tableView: UITableView = {
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
        let available = gifts.filter() { $0.eventId == nil || $0.eventId == "" }
        
        self.dataSource = available
        setTableViewHeight()
    }
    
    private func setupSubviews() {
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
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
        getDataSource()
    }
    
}

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
        let cell = tableView.cellForRow(at: indexPath) as! GiftSelectTableViewCell
        let gift = cell.gift!
        
        self.delegate?.selectedGift(gift)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GiftSelectTableViewCell.cellHeight
    }
}
