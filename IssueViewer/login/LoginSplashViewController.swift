//
//  LoginSplashViewController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 7/8/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SafariServices


final class LoginSplashViewController: UIViewController {

   

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!




    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.layer.cornerRadius = 8
 
    }

   

    @IBAction func onSignInButton(_ sender: Any) {
//        SFAuthenticationSession
        
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let login = Storyboard.Main.navigationControllerWithClass(HomeTabBarController.self)
        let ctrl = GrantAccesViewController { _ in
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = login
            appDelegate.window = window
            window.makeKeyAndVisible()
            
        }
        
        let nav = UINavigationController(rootViewController: ctrl)
        present(nav, animated: true)
    }

    @IBAction func onPersonalAccessTokenButton(_ sender: Any) {
       
    }

    private func handleError() {
       
    }

  


}
