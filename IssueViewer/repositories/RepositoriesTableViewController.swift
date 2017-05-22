//
//  RepositoriesTableViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 8/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Colors.controller_background

	}



	override func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "MayorgaFirm"
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoriesTableViewCell", for: indexPath)



		return cell
	}


}
