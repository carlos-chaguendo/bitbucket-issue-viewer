//
//  UIColor.swift
//  test-ios
//
//  Created by carlos chaguendo on 24/02/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

public extension UIColor {

	public static func Hex(_ rgbValue: UInt32) -> UIColor {
		let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
		let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
		let blue = CGFloat(rgbValue & 0xFF) / 256.0

		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}

	public func toHexString() -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0

		getRed(&r, green: &g, blue: &b, alpha: &a)

		let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

		return NSString(format: "#%06x", rgb) as String
	}
    
    
  
    public func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:1, height:1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
