//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import RealmSwift
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
        // Print path to Realm database.
        // print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
            // Initialise Realm.
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }

        return true
    }
}
