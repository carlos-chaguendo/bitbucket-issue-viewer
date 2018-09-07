//
//  Popover.swift
//  test-ios
//
//  Created by carlos chaguendo on 17/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

class PopoverBackgroundView: UIPopoverBackgroundView, UIPopoverPresentationControllerDelegate {


	var _arrowOffset: CGFloat = 0.0
	var _arrowDirection: UIPopoverArrowDirection = .any
	var _arrowHeight: CGFloat = 10.0
	var _arrowImageView: UIImageView

	override init(frame: CGRect) {
		_arrowImageView = UIImageView(frame: CGRect(x: 0, y: 10, width: _arrowHeight * 2, height: _arrowHeight * 2))

		super.init(frame: frame)
		addSubview(_arrowImageView)
		layer.shadowColor = UIColor.gray.withAlphaComponent(0.8).cgColor
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		var arrowCenter: CGPoint = .zero

		let backgroundFrame = self.frame;

		if _arrowDirection == .up {
			_arrowImageView.backgroundColor = Colors.NavBar.background

			arrowCenter = CGPoint(x: backgroundFrame.size.width * 0.5 + self.arrowOffset, y: _arrowHeight);
		}

		if _arrowDirection == .down {
			_arrowImageView.backgroundColor = UIColor.white
			arrowCenter = CGPoint(x: backgroundFrame.size.width * 0.5 + self.arrowOffset, y: backgroundFrame.size.height - _arrowHeight * 0.99);
		}

		//		if _arrowDirection == .left {
		//			arrowCenter = CGPoint(x: backgroundFrame.size.width * 0.5 + self.arrowOffset, y: _arrowHeight);
		//		}
		//
		//		if _arrowDirection == .right {
		//			arrowCenter = CGPoint(x: backgroundFrame.size.width * 0.5 + self.arrowOffset, y: _arrowHeight);
		//		}

		_arrowImageView.center = arrowCenter
		_arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
	}

	/* Represents the the length of the base of the arrow's triangle in points.
     */
	public override static func arrowBase() -> CGFloat {
		return 10;
	}


	/* Describes the distance between each edge of the background view and the corresponding edge of its content view (i.e. if it were strictly a rectangle).
     */
	public override static func contentViewInsets() -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}


	public override static func arrowHeight() -> CGFloat {
		return 10;
	}


	/* The arrow offset represents how far from the center of the view the center of the arrow should appear. For `UIPopoverArrowDirectionUp` and `UIPopoverArrowDirectionDown`, this is a left-to-right offset; negative is to the left. For `UIPopoverArrowDirectionLeft` and `UIPopoverArrowDirectionRight`, this is a top-to-bottom offset; negative to toward the top.
     
     This method is called inside an animation block managed by the `UIPopoverController`.
     */
	public override var arrowOffset: CGFloat {
		get { return _arrowOffset }
		set { _arrowOffset = newValue; self.setNeedsLayout() }
	}


	/* `arrowDirection` manages which direction the popover arrow is pointing. You may be required to change the direction of the arrow while the popover is still visible on-screen.
     */
	public override var arrowDirection: UIPopoverArrowDirection {
		get { return _arrowDirection }
		set { _arrowDirection = newValue ; self.setNeedsLayout() }
	}


	/* This method may be overridden to prevent the drawing of the content inset and drop shadow inside the popover. The default implementation of this method returns YES.
     */
	public override class var wantsDefaultContentAppearance: Bool { return true }




}
