//
//  AppDelegate.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Configure Realm
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                //  if oldSchemaVersion < 3 {
                //      // Realm automatically detects new properties and updates the schema on disk
                //  }
        },
            deleteRealmIfMigrationNeeded: true
        )
        Realm.Configuration.defaultConfiguration = config

        return true
    }

}

