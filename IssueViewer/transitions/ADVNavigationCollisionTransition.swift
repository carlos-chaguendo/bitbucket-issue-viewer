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

		guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else {
			return
		}

		let containerView = transitionContext.containerView
		containerView.backgroundColor = .clear

        let navigationController = (isShowing ? toVC : fromVC ) as! UINavigationController
		let navigationContainer = (navigationController.value(forKey: "navigationTransitionView") as! UIView)
        let navigationBar = navigationController.navigationBar
        
        let navBarHeight = UIApplication.shared.statusBarFrame.height + navigationController.navigationBar.frame.height
        
		// Preparacion para a animacion
		if isShowing {
			navigationController.navigationBar.transform = CGAffineTransform(translationX: 0, y: -navBarHeight)
			navigationContainer.transform = CGAffineTransform(translationX: 0, y: navigationContainer.frame.height)
			containerView.addSubview(navigationController.view)
		} else {
			containerView.backgroundColor = .red
			containerView.insertSubview(toVC.view, at: 0)
		}

        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [ !self.isShowing ? .curveEaseIn :  .curveEaseOut ],
            animations: {
                if self.isShowing {
                    navigationBar.transform = CGAffineTransform.identity
                    navigationContainer.transform = CGAffineTransform.identity
                } else {
                    navigationBar.transform = CGAffineTransform(translationX: 0, y: -navBarHeight)
                    navigationContainer.transform = CGAffineTransform(translationX: 0, y: navigationContainer.frame.height)
                }
        }, completion:  { _ in
            transitionContext.completeTransition(true)
        })
	}

}
