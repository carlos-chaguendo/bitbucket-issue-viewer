//
//  UIImage.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 20/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit

extension UIImage {
	public class func colorForNavBar(color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()

		context!.setFillColor(color.cgColor)
		context!.fill(rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}
}
