//
//  StatusSelectViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

public class StatusSelectViewController: LiveScrollWithMultipleSelectionTableViewController {

	public var status = [String]()

	override public func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")

		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmisViewController(_:)))
		navigationItem.setRightBarButton(done, animated: false)
		title = "Status"
	}

	public override func liveScroll(valuesOf page: Int) {
		self.loadInformation = true;
		self.hasMore = false
		let status = ["wontfix", "invalid", "new", "closed", "resolved", "on hold" , "duplicate"].map({ NSString(string: $0) })
		self.appendValues(status)
		self.tableView.reloadData()
	}

	override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "defaultCell")

		guard let status = values[safe: indexPath.row] as? String else {
			return cell
		}


		if self.status.contains(status) == true {
			stylesForSelected(cell: cell)
			_selectedIndexs.append(indexPath)
		}

		cell.textLabel?.text = status
		cell.selectionStyle = .none
		return cell
	}

	public override var preferredContentSize: CGSize {
		set {

		}
		get {
			return CGSize(width: 250, height: 300)

		}
	}
}
