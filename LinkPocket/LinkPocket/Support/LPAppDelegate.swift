//
//  AppDelegate.swift
//  LinkPocket
//
//  Created by 내 맥북에어 on 2018. 7. 24..
//  Copyright © 2018년 LP. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class LPAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarVC: LPCustomTabBarController = LPCustomTabBarController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        let parentNavi = LPParentNavigationController.sharedInstance
        let vc1: LPRecentViewController = LPRecentViewController()
        let vc2: LPCategoryViewController = LPCategoryViewController()

        vc1.tabBarItem.title = "RECENT"
        vc2.tabBarItem.title = "CATEGORY"
        
        tabBarVC.viewControllers = (NSArray(array: [vc1, vc2]) as? [UIViewController])!
        
        parentNavi.pushViewController(tabBarVC, animated: false)
        parentNavi.navigationBar.isTranslucent = false
        parentNavi.navigationBar.shadowImage = UIImage()
        parentNavi.navigationBar.backIndicatorImage = UIImage()
        parentNavi.navigationBar.tintColor = .black
        
        window? = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = parentNavi
        
        self.window?.makeKeyAndVisible()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().layer.borderWidth = 0
        UITabBar.appearance().clipsToBounds = true

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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        if url.scheme == "OpenLinkPocket"
        {
            let eachCategoryVC = EachCategoryController()
            let urls = LPCoreDataManager.store.selectAllObjectFromLink() as! [LPLinkModel]
            let categoryUrls = urls.filter { $0.category?.name == url.host! }
            var sectionModel: [LPTableSectionModel] = LPGroupingTable(urls: categoryUrls)
            sectionModel = sectionModel.sorted(by: { $0.section > $1.section })

            eachCategoryVC.displayCategoryPage(categoryName: url.host!, categoryCount: "\(categoryUrls.count)", urls: sectionModel)
            
            for _ in 0 ..< LPParentNavigationController.sharedInstance.viewControllers.count - 1 {
                LPParentNavigationController.sharedInstance.popViewController(animated: false)
            }
            
            LPParentNavigationController.sharedInstance.pushViewController(eachCategoryVC, animated: true)
        }
        
        return true
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LinkPocket")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
