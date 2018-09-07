//
//  ADVNavigationCollisionTransition.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 13/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

class ADVNavigationCollisionTransition: NSObject, UIViewControllerAnimatedTransitioning {

	var isShowing = true

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 3
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

		let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!

		guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
			return
		}

		let containerView = transitionContext.containerView
		containerView.backgroundColor = .clear

		let navigationController: UINavigationController

		if isShowing {
			navigationController = toVC as! UINavigationController
		} else {
			navigationController = fromVC as! UINavigationController
		}

		let navigationContainer = (navigationController.value(forKey: "navigationTransitionView") as! UIView)


		// Preparacion para a animacion
		if isShowing {
			navigationController.navigationBar.transform = CGAffineTransform(translationX: 0, y: -64)
			navigationContainer.transform = CGAffineTransform(translationX: 0, y: navigationContainer.frame.height)
			containerView.addSubview(navigationController.view)
		} else {
			containerView.backgroundColor = .red
			containerView.insertSubview(toVC.view, at: 0)
		}



		UIView.animate(withDuration: 0.2, animations: {

			if self.isShowing {
				navigationController.navigationBar.transform = CGAffineTransform.identity
			} else {
				navigationController.navigationBar.transform = CGAffineTransform(translationX: 0, y: -64)
			}
		}) { finished in

		}

		UIView.animate(withDuration: 0.3, animations: {
			if self.isShowing {
				navigationContainer.transform = CGAffineTransform.identity
			} else {
				navigationContainer.transform = CGAffineTransform(translationX: 0, y: navigationContainer.frame.height)
			}
		}) { finished in

			transitionContext.completeTransition(true)

		}


	}

}
