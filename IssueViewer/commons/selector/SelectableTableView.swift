//
//  SelectableTableView.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Foundation


public protocol SelectableTableView {


	func stylesForSelected(cell: UITableViewCell)

	func stylesForUnselected(cell: UITableViewCell)

	func dissmisViewController(_ sender: Any)


}


extension SelectableTableView where Self: UITableViewController {

	public func stylesForSelected(cell: UITableViewCell) {
		cell.backgroundColor = Colors.primary.withAlphaComponent(0.1)
		cell.textLabel?.backgroundColor = UIColor.clear
		cell.accessoryType = .checkmark

	}

	public func stylesForUnselected(cell: UITableViewCell) {
		cell.backgroundColor = UIColor.clear
		cell.textLabel?.backgroundColor = UIColor.clear
		cell.accessoryType = .none
	}
}
