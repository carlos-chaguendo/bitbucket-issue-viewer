//
//  UIlabel+Ionicons.swift
//  test-ios
//
//  Created by carlos chaguendo on 24/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import IoniconsSwift

public extension UIFont {

	public static func ionicon(ofSize size: CGFloat) -> UIFont {
		return Ionicons.ionic.label(size).font
	}

}

public extension String {
	public static func ionicon(of icon: Ionicons) -> String {
		return icon.description
	}
}
