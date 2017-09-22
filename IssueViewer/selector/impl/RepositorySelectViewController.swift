//
//  RepositorySelectViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import PromiseKit

public class RepositorySelectViewController: LiveScrollWithSingleSelectionTableViewController {

	public var repository: Repository?
    public var team: Team!



	override public func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
	}


	public override func liveScroll(valuesOf page: Int) {

		RepositoryService.repositories(for: team!.username!, page: page)
			.then(execute: { (result: SearchResult<Repository>?) -> Void in
				guard let repositories = result?.values else {
					self.hasMore = false
					return
				}

				if repositories.count <= 0 {
					self.hasMore = false
				}

				self.appendValues(repositories)


				self.loadInformation = true;
				self.tableView.reloadData()
			}).always (execute: {
				self.loadInformation = true;
			}).catch (execute: self.presentError)

	}


	override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "defaultCell")
		guard let repository = values[safe: indexPath.row] as? Repository else {
			return cell
		}

		if let selectedRepo = self.repository, selectedRepo.slug == repository.slug {
			stylesForSelected(cell: cell)
			_selectedIndex = indexPath
		}

		cell.textLabel?.text = repository.name
		cell.selectionStyle = .none
		return cell
	}


}
