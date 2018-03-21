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
        tv.backgroundColor = UIColor.clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(GiftSelectTableViewCell.self, forCellReuseIdentifier: "giftSelectCell")
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Gift"
        
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTouched(sender:)))
        
        self.navigationItem.leftBarButtonItem = backButton
        
        setupSubviews()
    }
    
    private func getDataSource() {
        guard let p = self.person else { return }
        guard let gifts = p.gift?.allObjects as? [Gift] else { return }

        self.dataSource = gifts
    }
    
    private func setupSubviews() {
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        self.getDataSource()
    }
    
    @objc
    func backButtonTouched(sender: UIButton) {
        
        print("Back button touched")
        navigationController?.popViewController(animated: true)
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
}
