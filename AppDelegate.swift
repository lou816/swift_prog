//
//  AppDelegate.swift
//  FoodPin
//
//  Created by Simon Ng on 14/10/2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if UserDefaults.isFirstLaunch() {
            //顯示新手指導頁面
            print("first open setting")
            insert(name: "豬", image: UIImage(named: "豬")!)
            insert(name: "蠟筆小新", image: UIImage(named: "蠟筆小新")!)
            insert(name: "皮卡丘", image: UIImage(named: "皮卡丘")!)
//            insert(name: "甜筒", image: UIImage(named: "甜筒")!)
//            insert(name: "海龜", image: UIImage(named: "海龜")!)
            insert(name: "企鵝", image: UIImage(named: "企鵝")!)
            insert(name: "柴犬", image: UIImage(named: "柴犬")!)
            insert(name: "機器人", image: UIImage(named: "機器人")!)
            insert(name: "魚", image: UIImage(named: "魚")!)
            insert(name: "恐龍", image: UIImage(named: "恐龍")!)
            insert(name: "兔子", image: UIImage(named: "兔子")!)
        }
        

        let navBarAppearance = UINavigationBarAppearance()
        
        var backButtonImage = UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20.0, weight: .bold))
        
        backButtonImage = backButtonImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0))
        navBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        UINavigationBar.appearance().tintColor = .systemOrange
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        return true
 
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Topic")
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
//
    func insert(name: String, image: UIImage) {
        var newPicture: Picture!
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            newPicture = Picture(context: appDelegate.persistentContainer.viewContext)
            newPicture.name = name

            if let imageData = image.pngData() {
                newPicture.image = imageData
            }
            appDelegate.saveContext()
        }
    }
//
}

//
extension UserDefaults {
    static func isFirstLaunch() -> Bool {
            let hasBeenLaunched = "hasBeenLaunched"
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
            if isFirstLaunch {
                UserDefaults.standard.set(true, forKey: hasBeenLaunched)
                UserDefaults.standard.synchronize()
            }
            return isFirstLaunch
        }
}
//
