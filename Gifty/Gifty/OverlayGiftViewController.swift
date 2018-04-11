//
//  OverlayGiftViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-04-10.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation
import GiftyBridge

class OverlayGiftViewController: UIViewController {
    
    var event: Event? {
        didSet {
            setDatasource()
        }
    }
    
    private var datasource: [Gift]? {
        didSet {
            setTableViewHeight()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    let bgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageNames.horizontalBGGradient.rawValue))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(Theme.colors.lightToneOne.color, for: .highlighted)
        button.addTarget(self, action: #selector(okButtonTouched(sender:)), for: .touchUpInside)
        return button
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = Theme.fonts.subtitleText.font
        label.text = "Gifts"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(GiftCompletionTableViewCell.self, forCellReuseIdentifier: "overlayGiftCell")
        tv.dataSource = self
        tv.delegate = self
        tv.bounces = false
        return tv
    }()
    
    private var cellHeight: CGFloat = 50.0
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let c = tableViewHeightConstraint else { return }
        var height = 80.0 + c.constant + 30.0
        height = height > 220 ? height : 220
        
        view.bounds.size = CGSize(width: UIScreen.main.bounds.width - 40, height: height)
        view.backgroundColor = UIColor.colorWithVals(r: 206, g: 78, b: 120)
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    
    private func setupSubviews() {
        
        view.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bgView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        view.addSubview(headingLabel)
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: pad),
            headingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: pad),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: pad),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -pad)
            ])
        
        var constant: CGFloat = 0.0
        if let d = datasource {
            constant = CGFloat(d.count) * cellHeight
        }
        
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: tableView,
                                                       attribute: .height,
                                                       multiplier: 0,
                                                       constant: constant)
        tableViewHeightConstraint!.isActive = true
        tableView.addConstraint(tableViewHeightConstraint!)
        
        view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            okButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            okButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8),
            okButton.heightAnchor.constraint(equalToConstant: 30),
            ])
    }

    private func setDatasource() {
        guard let event = self.event else { return }
        
        if let gifts = GiftFRC.getGifts(for: event) {
            self.datasource = gifts
        }
    }
    
    private func setTableViewHeight() {
        guard let c = tableViewHeightConstraint, let d = datasource else { return }
        
        c.constant = CGFloat(d.count) * cellHeight
        print("datasource count is: \(d.count)")
        
    }

    @objc private func okButtonTouched(sender: UIButton) {
        print("ok button touched")
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension OverlayGiftViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overlayGiftCell") as! GiftCompletionTableViewCell
        if let gift = datasource?[indexPath.row] {
            cell.delegate = self
            cell.setup(with: gift)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GiftCompletionTableViewCell
        cell.changeCompleteValue()
    }
    
}

extension OverlayGiftViewController : GiftCompletionCellDelegate {

    private func checkEventCompleted() -> Bool {
        guard let gifts = datasource else { return true }
        
        for gift in gifts {
            if !gift.isCompleted {
                return false
            }
        }
        return true
    }
    
    func didChange(gift: Gift, to complete: Bool) {
        gift.isCompleted = complete
        
        guard let id = gift.eventId, let moc = gift.managedObjectContext else { return }
        guard let event = EventFRC.getEvent(forId: id, with: moc) else { return }
        
        event.isComplete = checkEventCompleted()
        
        ManagedObjectBuilder.saveChanges(dataPersistence: DataPersistenceService.shared) { (success) in
            print("Gift: \(String(describing: gift.name)) changed to complete: \(complete) and saved.")
        }
        
        let userInfo = ["giftId" : gift.id, "dateString": event.dateString]
        DispatchQueueHandler.notification.queue.async {
            NotificationCenter.default.post(name: Notifications.names.actionStateChanged.name, object: nil, userInfo: userInfo)
        }
    }
}
