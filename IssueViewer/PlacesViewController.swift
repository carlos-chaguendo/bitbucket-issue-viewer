//
//  PlacesViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 16/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {


	override func viewDidLoad() {
		super.viewDidLoad()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
		self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
         self.navigationController?.setToolbarHidden(false, animated: true)
		UIView.animate(withDuration: 0.7) {
			UIApplication.shared.statusBarView?.backgroundColor = Colors.status_bar
		}
	}

}
