//
//  UserSelectViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 28/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import PromiseKit
import Core

public class UserSelectViewController: LiveScrollWithSingleSelectionTableViewController<Assignee> {



	public var user: Assignee?
	private var promises = [Promise<SearchResult<Assignee>?>]()

	override public func viewDidLoad() {
		super.viewDidLoad()
		tableView.registerNibWithClass(TableViewCellWithPhoto.self)
	}


	public override func liveScroll(valuesOf page: Int) {
		TeamsService.members(of: "mayorgafirm", page: currentPage)
			.done { (result: SearchResult<Assignee>?) -> Void in
				guard let members = result?.values else {
					self.hasMore = false
					return
				}

				if members.count <= 10 {
					self.hasMore = false
				}

				self.appendValues(members)
				self.loadInformation = true;
				self.tableView.reloadData()

			}.ensure {
				self.loadInformation = true;
			}.catch (execute: self.presentError)
        
        
        

	}


	override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: TableViewCellWithPhoto = tableView.dequeueReusableCellWithClass(TableViewCellWithPhoto.self)!

		guard let user = values[safe: indexPath.row] else {
			return cell
		}

		if let selectedUser = self.user, selectedUser.uuid == user.uuid {
			stylesForSelected(cell: cell)
			_selectedIndex = indexPath
		}

		cell.avatar?.setImage(fromURL: user.avatar, animated: true)
		cell.title?.text = user.displayName
		cell.selectionStyle = .none
		return cell
	}

}
