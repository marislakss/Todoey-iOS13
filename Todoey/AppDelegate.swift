//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Lifecycle Methods

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func applicationWillTerminate(_: UIApplication) {
        saveContext()
    }

    // MARK: - Core Data stack

    // Lazy var is only loaded when it is called.
    lazy var persistentContainer: NSPersistentContainer = {
        // Create a persistent container (in default it is SQLite database).
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    // Helper method to save context when application is terminated.
    func saveContext() {
        // Context is like a temporary area where you can modify your data.
        // Similar to a staging area in Git.
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                // Save context to persistent container.
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
