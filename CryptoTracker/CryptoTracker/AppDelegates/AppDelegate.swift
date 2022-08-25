//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Huy Hà on 8/10/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CrytoTrackerer")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print(error)
            }
        })
        return container
    }()
}
