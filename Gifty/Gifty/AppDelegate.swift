//
//  AppDelegate.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = setupTabBarController()
        
        //MARK: testing functions
        //ManagedObjectBuilder.deleteAllPeople()
        
        //MARK: custom status bar
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.clear
        window?.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.frame = CGRect(x: 0, y: 0, width: (window?.frame.width)!, height: 20)
        
        return true
    }
    
    private func setupTabBarController() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        let calendarVC = UINavigationController.setupCustomNavigationController(CalendarViewController())
        let peopleVC = UINavigationController.setupCustomNavigationController(PeopleViewController())
        let settingsVC = UINavigationController.setupCustomNavigationController(SettingsViewController())
        
        tabBarController.viewControllers = [calendarVC, peopleVC, settingsVC]
        
        tabBarController.tabBar.barTintColor = ColorManager.tabBarPurple
        
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 2, height: 5)
        tabBarController.tabBar.layer.shadowOpacity = 0.5
        tabBarController.tabBar.layer.shadowRadius = 3

        return tabBarController
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //TODO: refresh calendar view
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersonEventModel")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
        return container
    }()

    func saveContext() {
        let moc = persistentContainer.viewContext
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

