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
import Core

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.




        UINavigationBar.appearance().tintColor = Colors.NavBar.buttons//UIColor.Hex(0xffffff) // Color de los botones
        UINavigationBar.appearance().barTintColor = Colors.NavBar.background
        UINavigationBar.appearance().backgroundColor = Colors.NavBar.background
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Colors.NavBar.title]
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        UITableView.appearance().separatorColor = Colors.Controller.background
        UITableViewCell.appearance().tintColor = Colors.primary

//        UIApplication.shared.statusBarView?.backgroundColor = Colors.status_bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

        UIToolbar.appearance().tintColor = Colors.primary
        UIToolbar.appearance().layer.borderWidth = 1;
        UIToolbar.appearance().layer.borderColor = Colors.primary.cgColor
        UIToolbar.appearance().clipsToBounds = true


        UITabBar.appearance().clipsToBounds = false
        UITabBar.appearance().tintColor = Colors.TapBar.tint
        UITabBar.appearance().barTintColor = Colors.TapBar.background
        UITabBar.appearance().unselectedItemTintColor = Colors.TapBar.unselectedTint


        print("Real \(Realm.Configuration.defaultConfiguration)")
        
        
        if SessionService.islogged == false {
            showLoginView()
        }

        
        
        return true
    }
    
    func showLoginView() {
        guard let window = window else {
            preconditionFailure()
        }
        
        let login = Storyboard.OauthLogin.viewControllerWithClass(LoginSplashViewController.self)
        if let root = window.rootViewController {
            login.view.frame = root.view.frame
            login.view.layoutIfNeeded()
        }
        
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
            window.rootViewController = login
        }, completion: { completed in
            // maybe do something here
        })
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let components = URLComponents(string:url.absoluteString.replacingOccurrences(of: "issueviewer:bit%23", with: "http://mysite3994.com?"))?.queryItems?.groupBy({ $0.name }),
//            let token = components["access_token"]?.first?.value, let type =  components["token_type"]?.first?.value {
//
//            Http.updateAut(token: token, tokenType: type)
//            return true
//        }
//  
//        
//        return false
//        
//    }



}

