//
//  AppDelegate.swift
//  Gifty
//
//  Created by Tim Beals on 2017-06-19.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit
import GiftyBridge
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        SettingsHandler.shared.getSettings()
        
        window?.rootViewController = setupTabBarController()
        
        //MARK: custom status bar
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.clear
        window?.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.frame = CGRect(x: 0, y: 0, width: (window?.frame.width)!, height: 20)
        
        //MARK: setup interstitials
        InterstitialService.shared.delegate = self
        InterstitialService.shared.createAndLoadInterstitial()
        InterstitialService.shared.setupTimer()
        
        return true
    }
    
    private func setupTabBarController() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        let calendarVC = UINavigationController.setupCustomNavigationController(CalendarViewController())
        let peopleVC = UINavigationController.setupCustomNavigationController(PeopleViewController())
        let settingsVC = UINavigationController.setupCustomNavigationController(SettingsViewController())
        tabBarController.viewControllers = [calendarVC, peopleVC, settingsVC]
        tabBarController.tabBar.barTintColor = Theme.colors.darkPurple.color
        tabBarController.tabBar.unselectedItemTintColor = Theme.colors.lightToneOne.color
        tabBarController.tabBar.tintColor = UIColor.white
        
        let icons = [ImageNames.calendarIcon.rawValue, ImageNames.peopleIcon.rawValue, ImageNames.settingsIcon.rawValue]
        for (index, item) in tabBarController.tabBar.items!.enumerated() {
            item.title = ""
            item.image = UIImage(named: icons[index])?.withRenderingMode(.alwaysTemplate)
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 2, height: 5)
        tabBarController.tabBar.layer.shadowOpacity = 0.5
        tabBarController.tabBar.layer.shadowRadius = 3

        return tabBarController
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let query = url.query else { return false }
        
        if query.hasPrefix("q=") {
            let dateString = query.replacingOccurrences(of: "^q=", with: "", options: .regularExpression, range: nil)
            guard dateString.count == 8 else { return false }
            let year = String(Array(dateString)[0...3])
            let month = String(Array(dateString)[4...5])
            let day = String(Array(dateString)[6...7])
            
            guard let showDate = DateHandler.dateWith(dd: day, MM: month, yyyy: year) else { return false }
            
            guard let tabBarController = self.window?.rootViewController as? UITabBarController else { return false}
            tabBarController.selectedIndex = 0
            let navCon = tabBarController.selectedViewController as? UINavigationController
            let calVc = navCon?.viewControllers.first as? CalendarViewController
            calVc?.scrollToDateAndSelect(date: showDate)
            
            return true
        }
        return true
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
        
        if let moc = DataPersistenceService.shared.dpMainQueueContext {
            DataPersistenceService.shared.dpSaveToContext(moc)
        }
                
        InterstitialService.shared.dispose()
    }
    
}

extension AppDelegate: InterstitialServiceDelegate {
    
    func interstitialTimerExecuted() {
        guard let tabBarController = self.window?.rootViewController as? UITabBarController else { return }
        guard let navCon = tabBarController.selectedViewController as? UINavigationController else { return }
        guard let vc = navCon.topViewController else { return }
        InterstitialService.shared.showInterstitial(in: vc)
    }
}
