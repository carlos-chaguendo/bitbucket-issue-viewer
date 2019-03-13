//
//  LiveScrollWithSingleSelectionTableViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 17/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Foundation
import Core
import PromiseKit

public class LiveScrollWithSingleSelectionTableViewController<Element>: LiveScrollTableViewController<Element>, SelectableTableView {

    public let (promise, resolve) = Promise<Element?>.pending()
	public var _selectedIndex: IndexPath?
	public var dissmisWhenSelect = true

    deinit {
        resolve.reject(NSError(domain: "ls-ml-seld", code: 1, userInfo: [NSLocalizedDescriptionKey:" Closed witout dissmisViewController"]))
    }

	@IBAction public func dissmisViewController(_ sender: Any) {
		if let index = _selectedIndex {
            resolve.fulfill(self.values[safe: index.row])
        } else {
             resolve.fulfill(nil)
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
