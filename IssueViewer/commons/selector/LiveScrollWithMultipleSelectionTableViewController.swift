//
//  LiveScrollWithMultipleSelection.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Core
import PromiseKit

public class LiveScrollWithMultipleSelectionTableViewController<Element>: LiveScrollTableViewController<Element>, SelectableTableView {

	public var _selectedIndexs = [IndexPath]()
    
    public let (promise, resolve) = Promise<[Element]>.pending()
    
    deinit {
        resolve.reject(NSError(domain: "ls-ml-seld", code: 1, userInfo: [NSLocalizedDescriptionKey:" Closed witout dissmisViewController"]))
    }


	@IBAction public func dissmisViewController(_ sender: Any) {
        let values = self._selectedIndexs.map({ self.values[$0.row] })
        resolve.fulfill(values)
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
