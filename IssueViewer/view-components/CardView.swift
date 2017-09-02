//
//  CardView.swift
//  test-ios
//
//  Created by carlos chaguendo on 24/02/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

	//@IBInspectable var cornerRadius: CGFloat = 3

	@IBInspectable var shadowOffsetWidth: Int = 0
	@IBInspectable var shadowOffsetHeight: Int = 1
	//@IBInspectable var shadowColor: UIColor? = UIColor.black
	//@IBInspectable var shadowOpacity: Float = 0.3

	//@IBInspectable var borderWidth: CGFloat = 0.3
	//@IBInspectable var borderColor: UIColor = UIColor.gray

	override func layoutSubviews() {
		layer.cornerRadius = cornerRadius
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

		layer.masksToBounds = false
		layer.shadowColor = shadowColor?.cgColor
		layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
		layer.shadowOpacity = shadowOpacity
		layer.shadowPath = shadowPath.cgPath
		layer.shadowRadius = cornerRadius

		self.layer.borderWidth = borderWidth
		//self.layer.borderColor = borderColor.cgColor

	}

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

}
