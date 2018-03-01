//
//  CreateEventNotificationViewController.swift
//  Gifty
//
//  Created by Tim Beals on 2018-02-21.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge

class CreateEventNotificationViewController: CustomViewController {

    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let event = self.event else { return }
//        let nb = EventNotificationBuilder.newNotificaation(for: event)
//        nb.moBuilder.addDate(Date(timeInterval: 30.0, since: Date()))
//            .addMessage("This is my message")
//            .addTitle("Hello!")
//        _ = nb.createNewNotification()
//        nb.saveChanges(DataPersistenceService.shared)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: ImageNames.back.rawValue),
                                         style: .plain, target: self, action: #selector(backButtonTouched(sender:)))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc
    func backButtonTouched(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}
