//
//  LiveScrollWithMultipleSelection.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit


@objc
public protocol MultipleSelectionTableViewDelegate: NSObjectProtocol {

	@objc optional func multipleSelectionTableView(selectionTable: UITableViewController, dismissWith selected: [Any])

}

public class LiveScrollWithMultipleSelectionTableViewController: LiveScrollTableViewController, SelectableTableView {

	public weak var delegate: MultipleSelectionTableViewDelegate?
	public var _selectedIndexs = [IndexPath]()

	@IBAction public func dissmisViewController(_ sender: Any) {

		if let delegate = delegate, let multipleSelectionTableView = delegate.multipleSelectionTableView {
			let values = self._selectedIndexs.map({ self.values[$0.row] })
			multipleSelectionTableView(self, values)
		}

		dismiss(animated: true, completion: nil)
	}

	override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		guard let cell = tableView.cellForRow(at: indexPath) else {
			return
		}

		if _selectedIndexs.contains(indexPath) {
			// existe un index selecionado, se des seleciona
			stylesForUnselected(cell: cell)
			let _ = _selectedIndexs.remove(callback: { $0 == indexPath })
			return
		}

		stylesForSelected(cell: cell)
		_selectedIndexs.append(indexPath)
	}



}



