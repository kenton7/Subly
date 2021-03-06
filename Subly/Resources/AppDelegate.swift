//
//  AppDelegate.swift
//  Subly
//
//  Created by Илья Кузнецов on 27.01.2021.
//

import UIKit
import CoreData
import RealmSwift
import UserNotifications
import LocalAuthentication

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    let notificationCenter = UNUserNotificationCenter.current()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let schemaVersion: UInt64 = 13
        //создаем новую конфигурацию
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: schemaVersion,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < schemaVersion) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10,
                                                                         weight: .semibold)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.bool(forKey: "faceId") {
            print("true")
            let context = LAContext()
            var error: NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                         error: &error) {
                let reason = "Пожалуйста, авторизуйтесь с помощью Touch ID."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: reason) { [weak self] (success, error) in
                    DispatchQueue.main.async {
                        guard success, error == nil else {
                            //failed
                            
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainViewController = mainStoryboard.instantiateViewController(identifier: "FirstViewController")
                            let navigationController = UINavigationController(rootViewController: mainViewController)
                            self!.window?.rootViewController = navigationController
                            self!.window?.makeKeyAndVisible()
                            
                            let alert = UIAlertController(title: "Авторизация не пройдена",
                                                          message: "Пожалуйста, попробуйте снова",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                            //self?.present(alert, animated: true, completion: nil)
                            return
                        }
                        //показываем другой экран
                        //success
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainViewController = mainStoryboard.instantiateViewController(identifier: "MainViewController")
                        let navigationController = UINavigationController(rootViewController: mainViewController)
                        self!.window?.rootViewController = navigationController
                        self!.window?.makeKeyAndVisible()
                        }
                    }
            } else {
                //can not use
                let alert = UIAlertController(title: "Ой!",
                                              message: "Вы не можете использовать эту функцию",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                //present(alert, animated: true, completion: nil)
            }
        } else {
            print("error")
        }
        
        ///Уведомления
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        ///запрашиваем у юзера разрешение на отправку уведомлений
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        ///трекаем, если юзер изменил доступ к уведомлениям в настройках
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
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
        let container = NSPersistentContainer(name: "Subly")
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

