//
//  UITableView.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

extension UITableView {

	func registerWithClass(_ cell: UITableViewCell.Type) {
		let className = String(describing: cell)
		register(cell, forCellReuseIdentifier: className)
	}

	func registerNibWithClass(_ cell: UITableViewCell.Type) {
		let className = String(describing: cell)
		register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
	}

	func dequeueReusableCellWithClass<T>(_ cell: T.Type) -> T? {
		let className = String(describing: cell)
		return dequeueReusableCell(withIdentifier: className) as? T
	}

	/// Los headers de las tablas no son dinamicos
	/// se necesita llamar a este metodo en `override func viewDidLayoutSubviews() {` o cuando se necesite
	func sizeHeaderToFit() {
		if let headerView = self.tableHeaderView {

			let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
			var headerFrame = headerView.frame

			//Comparison necessary to avoid infinite loop
			if height != headerFrame.size.height {
				headerFrame.size.height = height
				headerView.frame = headerFrame
				self.tableHeaderView = headerView
			}
		}
	}

}
