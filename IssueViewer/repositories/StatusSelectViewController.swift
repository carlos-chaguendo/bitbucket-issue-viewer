//
//  StatusSelectViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

public class StatusSelectViewController: LiveScrollWithMultipleSelectionTableViewController<String> {

	public var status = [String]()

	override public func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")

		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmisViewController(_:)))
		navigationItem.setRightBarButton(done, animated: false)
		title = "Status"
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeThisViewController))
        navigationItem.setLeftBarButton(cancel, animated: false)
	}
    
    @objc public func closeThisViewController() {
        self.dismiss(animated: true, completion: nil)
    }

	public override func liveScroll(valuesOf page: Int) {
		self.loadInformation = true;
		self.hasMore = false
		let status = ["wontfix", "invalid", "new", "closed", "resolved", "on hold" , "duplicate", "open"]
		self.appendValues(status)
		self.tableView.reloadData()
	}

	override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "defaultCell")

		guard let status = values[safe: indexPath.row] else {
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
			return CGSize(width: 250, height: 400)

		}
	}
}
