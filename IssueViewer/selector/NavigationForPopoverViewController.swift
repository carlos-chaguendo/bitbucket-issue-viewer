//
//  NavigationForPopoverViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 17/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Core
import Material

class NavigationForPopoverViewController: UINavigationController, UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    public var transition: ADVNavigationCollisionTransition?
    
    var mode: Int = 0
    
    public var statusBarViewColor: UIColor? = nil

	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)

		hidesBarsOnSwipe = false

		modalPresentationStyle = UIModalPresentationStyle.popover
		popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any

//        popoverPresentationController?.popoverBackgroundViewClass = PopoverBackgroundView.self
        
        mode = UserDefaults.standard["filter_display_mode"].or(else: 0)
        switch mode {
        case 0:
            popoverPresentationController?.delegate = self
            
            DispatchQueue.main.async(execute: {
                if let window = UIApplication.shared.statusBarView {
                    self.statusBarViewColor =  window.backgroundColor
                    window.backgroundColor = Colors.primary.withAlphaComponent(0.25)
                }
            })
            
        default:
            transitioningDelegate =  self
            transition = ADVNavigationCollisionTransition()
        }

        if let dimmingView = popoverPresentationController?.dimmingView {
            dimmingView.backgroundColor = Colors.primary.withAlphaComponent(0.5)
        }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async(execute: {
            if let window = UIApplication.shared.statusBarView {
                window.backgroundColor = self.statusBarViewColor
            }
        })
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
    
     public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition?.isShowing = true
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
          transition?.isShowing = false
       return transition
    }

}
