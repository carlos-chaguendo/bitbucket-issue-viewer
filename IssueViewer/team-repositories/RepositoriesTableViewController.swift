//
//  RepositoriesTableViewController.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 20/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit
import Core
import Material
import Alamofire

class RepositoriesTableViewController: LiveScrollTableViewController {

	var user: User!



	@objc override func viewDidLoad() {

		// setup tabale view
		tableView.do {
			$0.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
			$0.rowHeight = 98
			$0.estimatedRowHeight = 250
			$0.separatorColor = UIColor.clear
		}

		if Device.userInterfaceIdiom == .pad {
			let margin = UITableViewController().tableView.layoutMargins.left
			tableView.layoutMargins.left = margin
			tableView.layoutMargins.right = margin
		}

		super.viewDidLoad()
		refreshControl?.tintColor = UIColor.white
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.do {
			$0.hidesBarsOnSwipe = false
			$0.setNavigationBarHidden(true, animated: animated)
			$0.setToolbarHidden(true, animated: false)
		}

		tabBarController?.view.backgroundColor = Colors.primary
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		tabBarController?.tabBar.do {
			$0.isHidden = false
			$0.tintColor = UIColor.white
			$0.barTintColor = Colors.primary
			$0.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.4)
		}
        
        // HairPowder.instance.spread()

		UIApplication.shared.do {
			$0.statusBarView?.backgroundColor = Colors.primary
			$0.statusBarStyle = .lightContent
		}
	}



	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		tabBarController?.tabBar.do {
			$0.tintColor = Colors.TapBar.tint
			$0.barTintColor = Colors.TapBar.background
			$0.unselectedItemTintColor = Colors.TapBar.unselectedTint
		}

		UIApplication.shared.do {
			$0.statusBarView?.backgroundColor = nil
			$0.statusBarStyle = .default
		}
	}


	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		navigationController?.hidesBarsOnSwipe = true
	}


	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		guard let team = values[safe: indexPath.row] as? User else {
			self.view.makeToast("Team nor found")
			return
		}

		let issues = Storyboard.Issues.viewControllerWithClass(IssuesTableViewController.self)
		issues.team = team

		tabBarController?.tabBar.isHidden = true
		navigationController?.pushViewController(issues, animated: true)
	}

	override public func numberOfSections(in tableView: UITableView) -> Int {
		let n = super.numberOfSections(in: tableView)
		tableView.backgroundColor = Colors.primary
		return n;
	}

	/**
     * Metodo llamado cuando se realiza un avance de pagina mediante el scroll
     */
	override public func liveScroll(valuesOf page: Int) {


		UserService.getUser()
			.done { (user) -> Void in

				self.user = user!

				TeamsService.teams(refreshFromServer: self.loadFromServer)
					.done { (result) -> Void in


						if self.loadFromServer {
							self.removeAllValues()

							self.tableView.reloadData()
						}

						guard let teams = result?.values else {
							self.hasMore = false
							return
						}

						if teams.count <= 10 {
							self.hasMore = false
						}


						self.appendValues([self.user])
						self.appendValues(teams)
						self.loadInformation = true;
						self.loadFromServer = false
						self.tableView.reloadData()

					}.ensure {
						self.loadInformation = true;
						self.refreshControl?.endRefreshing()
					}.catch (execute: self.presentError)

			}.catch(execute: self.presentError)
	}


	override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellAsCard", for: indexPath) as? TeamTableViewCell else {
			return UITableViewCell(style: .subtitle, reuseIdentifier: "defaultCell")
		}

		cell.selectionStyle = .none
		cell.backgroundColor = Colors.primary

		guard let team = values[safe: indexPath.row] as? User else {
			return cell
		}


		cell.textLabel?.text = team.displayName
		cell.imageView?.setImage(fromURL: team.avatar, animated: true)
		loadExtaInformation(of: team, for: cell)
		return cell
	}

	/*
     Se encarga de cargar el numero de miembros y de repositorios que tiene cada GRUPO
     */
	private func loadExtaInformation(of team: User, for cell: TeamTableViewCell) {

		// solo los equipos tienen miembros
		if team.isType(.team) {
			if let members = team.numberOfmebers {
				cell.detailTextLabel?.text = "\(members) Members"
			} else {
				cell.detailTextLabel?.text = "Members"
				// Se cargan los Miembros
				TeamsService.count(membersOf: team)
					.done { (count) -> Void in
						cell.detailTextLabel?.text = "\(count) Members"
					}.end()
			}
		} else {
			cell.detailTextLabel?.text = ""
		}

		if let repositories = team.numberOfRepositories {
			cell.teamSubtitle?.text = "\(repositories) Repositories"
		} else {
			cell.teamSubtitle?.text = "Repositories"
			TeamsService.count(repositoriesOf: team)
				.done { (count) -> Void in
					cell.teamSubtitle?.text = "\(count) Repositories"
				}.end()
		}
	}





}
