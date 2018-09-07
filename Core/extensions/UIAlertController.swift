//
//  UIAlertController.swift
//  Core
//
//  Created by Carlos Chaguendo on 31/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

public extension UIAlertController {


	public convenience init(title: String, message: String, okLabel: String, cancelLabel: String, handler: @escaping (() -> Void), cancel: (() -> Void)? = nil) {
		self.init(title: title, message: message, preferredStyle: .alert)


		let buttonsHandler: (UIAlertAction) -> Void = { action in
			switch action.style {
			case .default: handler()
			case .cancel: cancel?()
			default: break
			}
		}

		addAction(UIAlertAction(title: okLabel, style: .default, handler: buttonsHandler))
		addAction(UIAlertAction(title: cancelLabel, style: .cancel, handler: buttonsHandler))
	}

	public convenience init(title: String, message: String, cancelLabel: String, destructiveLabel: String, handler: @escaping (() -> Void), destructive: (() -> Void)? = nil) {
		self.init(title: title, message: message, preferredStyle: .alert)


		let buttonsHandler: (UIAlertAction) -> Void = { action in
			switch action.style {
			case .cancel: destructive?()
			case .destructive: handler()
			default: break
			}
		}
		addAction(UIAlertAction(title: cancelLabel, style: .cancel, handler: buttonsHandler))
		addAction(UIAlertAction(title: destructiveLabel, style: .destructive, handler: buttonsHandler))
	}


	public func add(_ action: UIAlertAction) {
		self.addAction(action)
	}

}
