//
//  LiveScrollWithSingleSelectionTableViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 17/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Foundation

@objc
public protocol SingleSelectionTableViewDelegate {

	@objc optional func singleSelectionTableView(selectionTable: UITableViewController, dismissWith selected: BasicEntity)
	@objc optional func singleSelectionTableView(dismissWithClearFilter selectionTable: UITableViewController)
}


public class LiveScrollWithSingleSelectionTableViewController: LiveScrollTableViewController, SelectableTableView {


	public weak var delegate: SingleSelectionTableViewDelegate?
	public var _selectedIndex: IndexPath?
	public var dissmisWhenSelect = true


	@IBAction public func dissmisViewController(_ sender: Any) {

		if _selectedIndex == nil {
			delegate?.singleSelectionTableView?(dismissWithClearFilter: self)
			dismiss(animated: true, completion: nil)
			return
		}


		if let index = _selectedIndex,
			let delegate = delegate,
			let value = self.values[safe: index.row] as? BasicEntity {
			delegate.singleSelectionTableView?(selectionTable: self, dismissWith: value)


		}

		dismiss(animated: true, completion: nil)
	}



	override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) else {
			return
		}

		if let prevIndex = _selectedIndex, let prevCell = tableView.cellForRow(at: prevIndex) {
			// existe un index selecionado, se des seleciona
			stylesForUnselected(cell: prevCell)
			// es el mismo que se le da click
			if (indexPath == prevIndex) {
				_selectedIndex = nil
				return
			}
		}


		stylesForSelected(cell: cell)
		_selectedIndex = indexPath

		if dissmisWhenSelect {
			dissmisViewController(cell)
		}
	}
}
