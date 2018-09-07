//
//  Storyboard.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

enum Storyboard: String {
	case Main
	case Issues
	case Repositories
	case OauthLogin

	func storyboard() -> UIStoryboard {
		return UIStoryboard(name: self.rawValue, bundle: nil)
	}



	func navigationControllerWithClass<T>(_ className: T.Type) -> UINavigationController {
		let identifier = String(describing: className)

		guard let ctrl = storyboard().instantiateViewController(withIdentifier: "\(identifier)Nav") as? UINavigationController else {
			preconditionFailure("\(self.rawValue) not contains controller with identifier \(identifier)Nav")
		}

		return ctrl
	}


	func viewControllerWithClass<T>(_ className: T.Type) -> T {
		let identifier = String(describing: className)

		guard let ctrl = storyboard().instantiateViewController(withIdentifier: identifier) as? T else {
			preconditionFailure("\(self.rawValue) not contains controller with identifier \(identifier)")
		}

		return ctrl
	}

}
