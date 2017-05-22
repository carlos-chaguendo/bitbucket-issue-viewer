//
//  UITableView.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

extension UITableView {

	func registerNibWithClass(_ cell: UITableViewCell.Type) {
		let className = String(describing: cell)
		register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
	}

	func dequeueReusableCellWithClass<T>(_ cell: T.Type) -> T? {
		let className = String(describing: cell)
		return dequeueReusableCell(withIdentifier: className) as? T
	}

}
