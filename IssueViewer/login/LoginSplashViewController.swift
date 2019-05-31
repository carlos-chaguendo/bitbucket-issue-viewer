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
	@IBOutlet weak var imageView: UIImageView!


	override func viewDidLoad() {
		super.viewDidLoad()
		activityIndicator.hidesWhenStopped = true
		activityIndicator.stopAnimating()

		signInButton.layer.cornerRadius = 8
		signInButton.backgroundColor = Colors.primary
		imageView.image = Ionicons.socialBuffer.image(100, color: Colors.primary)
	}



	@IBAction func onSignInButton(_ sender: Any) {
//        SFAuthenticationSession

		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else {
			return
		}

		let login = Storyboard.Main.navigationControllerWithClass(HomeTabBarController.self)
		let ctrl = GrantAccesViewController { _ in

			UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
				window.rootViewController = login
			}, completion: { completed in
				// maybe do something here
			})
		}

		let nav = UINavigationController(rootViewController: ctrl)
		present(nav, animated: true)
	}

	@IBAction func onPersonalAccessTokenButton(_ sender: Any) {

	}

	private func handleError() {

	}




}
