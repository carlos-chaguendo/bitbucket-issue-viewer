//
//  AppDelegate.swift
//  test-ios
//
//  Created by carlos chaguendo on 24/02/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import ContactsUI
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.




        UINavigationBar.appearance().tintColor = Colors.navbar_button//UIColor.Hex(0xffffff) // Color de los botones
        UINavigationBar.appearance().barTintColor = Colors.navbar_back
        UINavigationBar.appearance().backgroundColor = Colors.navbar_back
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Colors.navbar_title]
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        UITableView.appearance().separatorColor = Colors.controller_background
        UITableViewCell.appearance().tintColor = Colors.primary

        UIApplication.shared.statusBarView?.backgroundColor = Colors.status_bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

        UIToolbar.appearance().tintColor = Colors.primary
        UIToolbar.appearance().layer.borderWidth = 1;
        UIToolbar.appearance().layer.borderColor = Colors.primary.cgColor
        UIToolbar.appearance().clipsToBounds = true


        UITabBar.appearance().clipsToBounds = false


print("Real \(Realm.Configuration.defaultConfiguration)")
        


        return true
    }



}

