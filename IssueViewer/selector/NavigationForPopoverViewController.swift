//
//  NavigationForPopoverViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 17/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

class NavigationForPopoverViewController: UINavigationController, UIPopoverPresentationControllerDelegate {

	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)

		hidesBarsOnSwipe = false

		modalPresentationStyle = UIModalPresentationStyle.popover
		popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
		popoverPresentationController?.delegate = self
		popoverPresentationController?.popoverBackgroundViewClass = PopoverBackgroundView.self
	}


	convenience init(rootViewController: UIViewController, sourceView: UIView?, sourceRect: CGRect?) {
		self.init(rootViewController: rootViewController)

		popoverPresentationController?.sourceView = sourceView
		popoverPresentationController?.sourceRect = sourceRect ?? CGRect.zero
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	/**
     Forza el modo popopver en el iphonee
     */
	public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}

}
