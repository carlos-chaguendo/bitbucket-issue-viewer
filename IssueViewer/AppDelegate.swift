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
import MessengerKit
import Bagel


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Bagel.start()

        let receipt = ReceiptPayload()
        receipt.name = "Carlos Chaguendo"
        receipt.number = "#CA-123456"
        receipt.paymentMethod = "Contra Entrega"

        receipt.address = ReceiptAddress()
        receipt.address?.street = "Edificio edgar negret"
        receipt.address?.city = "Popayan"
        receipt.address?.postalCode = "57"
        receipt.address?.state = "CAU"
        receipt.address?.country = "CO"

        receipt.summary = ReceiptSummary()
        receipt.summary?.subtotal = 75000
        receipt.summary?.shipping = 2000
        receipt.summary?.total = 0
        receipt.summary?.cost = 77000

        let element = ReceiptElement()
        element.title = "Arroz"
        element.subtitle = "Grano"
        element.price = 1800
        element.quantity = 6
        element.image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRapBqeP9JD66rY5ednAOelrflGOBawcx4FcbhpJxq3eK4NPN8k"
        
        let element1 = ReceiptElement()
        element1.title = "Azucar"
        element1.subtitle = "Granos"
        element1.price = 1200
        element1.quantity = 2
        element1.image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD57FiFP7b5Y4BT3ZdQGg_g9E-ntv5He6QUpIs40Iu80CTuH81Pg"

        receipt.elements.append(element)
        receipt.elements.append(element1)

 
        
        let buttonMessage = ButtonPayload()
        buttonMessage.text = "Hola Giles"
        
        let btn = MessageButton()
        
        btn.title = "Open Issue"
        btn.url = "http://gl.com"
        
        buttonMessage.buttons.append(btn)

      
        let message0 = SendMessage()
        message0.text = "Elver gomes  🚩"
        
    
        
        let message = SendMessageAttachment(content: receipt )
        
        // 1071504686219191
        // 1674813829258653
        // 2177295419019984  Magangue
        // 2030419673694526
//        MessengerService.send(message: message, to: "1674813829258653")
//            .done { (response) in
//
//                guard let response = response else {
//                    return
//                }
//
//                Logger.info("Capina  \(response)")
//
//            }.catch { (error) in
//                Logger.error("Error", error)
//        }
        

        UINavigationBar.appearance().tintColor = Colors.NavBar.buttons//UIColor.Hex(0xffffff) // Color de los botones
        UINavigationBar.appearance().barTintColor = Colors.NavBar.background
        UINavigationBar.appearance().backgroundColor = Colors.NavBar.background
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.NavBar.title]
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


        Logger.info("Real \(Realm.Configuration.defaultConfiguration)")


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

