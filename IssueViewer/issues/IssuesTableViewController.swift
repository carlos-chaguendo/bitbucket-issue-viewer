//
//  IssuesTableViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import ToastSwiftFramework
import NVActivityIndicatorView
import DropDown



public class IssuesTableViewController: LiveScrollTableViewController {

	@IBOutlet weak var search: UIBarButtonItem!
	@IBOutlet weak var btnRepository: UIBarButtonItem!


	fileprivate var assigne: Assignee?
	fileprivate var repository: Repository!
	fileprivate var status = [String]()

	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.setToolbarHidden(false, animated: true)
		navigationController?.hidesBarsOnSwipe = false
	}

	override public func viewDidLoad() {
		repository = Repository()
		repository?.slug = "adivantus-iphone"
		btnRepository.title = repository.slug!
		status = ["new", "close", "open"]

		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 250
	}


	/**
     * Metodo llamado cuando se realiza un avance de pagina mediante el scroll
     */
	override public func liveScroll(valuesOf page: Int) {

		IssuesService.issues(of: "mayorgafirm", inRepository: repository, assigneedTo: assigne, whitStatus: status, page: page, refreshFromServer: loadFromServer)

			.then (execute: { (result) -> Void in

				if self.loadFromServer {
					self.removeAllValues()
					self.tableView.reloadData()
				}

				guard let issues = result?.values else {
					self.hasMore = false
					return
				}

				if issues.count <= 10 {
					self.hasMore = false
				}

				self.appendValues(issues)
				self.loadInformation = true;
				self.tableView.reloadData()
			}).always (execute: {
				self.loadInformation = true;
				self.refreshControl?.endRefreshing()
			}).catch (execute: self.presentError)
	}

	@IBAction func showRepositorySelector(_ sender: UIBarButtonItem) {


		// get a reference to the view controller for the popover
		let selectviewController = Storyboard.Issues.viewControllerWithClass(RepositorySelectViewController.self)
		selectviewController.delegate = self
		selectviewController.repository = repository

		// present the popover
		var position = CGRect.zero
		position.origin.x = sender.plainView.bounds.midX
		position.origin.y = sender.plainView.bounds.midY - 10

		let popController = NavigationForPopoverViewController(rootViewController: selectviewController, sourceView: sender.plainView, sourceRect: position)

		self.present(popController, animated: true, completion: nil)
	}

	@IBAction func showUserSelector(_ sender: UIBarButtonItem) {
		// get a reference to the view controller for the popover
		let selectviewController = Storyboard.Issues.viewControllerWithClass(UserSelectViewController.self)
		selectviewController.user = assigne
		selectviewController.delegate = self

		// present the popover
		var position = CGRect.zero
		position.origin.x = sender.plainView.bounds.midX
		position.origin.y = sender.plainView.bounds.midY - 10

		let popController = NavigationForPopoverViewController(rootViewController: selectviewController, sourceView: sender.plainView, sourceRect: position)
		self.present(popController, animated: true, completion: nil)
	}


	@IBAction func showStatusSelector(_ sender: UIBarButtonItem) {
		// get a reference to the view controller for the popover
		let selectviewController = StatusSelectViewController()
		selectviewController.status = self.status
		selectviewController.delegate = self

		// present the popover
		var position = CGRect.zero
		position.origin.x = sender.plainView.bounds.midX
		position.origin.y = sender.plainView.bounds.midY - 10



		let popController = NavigationForPopoverViewController(rootViewController: selectviewController, sourceView: sender.plainView, sourceRect: position)
		self.present(popController, animated: true, completion: nil)
	}




	@IBAction func searchAction(_ sender: UIBarButtonItem) {
		showSearchBar()
	}


	override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: "issueViewCell", for: indexPath) as? IssueTableViewCell else {
			return UITableViewCell(style: .subtitle, reuseIdentifier: "defaultCell")
		}

		guard let issue = values[safe: indexPath.row] as? Issue else {
			return cell
		}

		cell.issue = issue
		return cell
	}


	override public func searchController(searchText: String, in value: AnyObject) -> Bool {
		guard let issue = value as? Issue else { return false }

		let inTitle = issue.title?.lowercased().contains(searchText.lowercased()) == true
		let inId = "#\(issue.id)".characters.starts(with: searchText.lowercased().characters) == true
		let inContent = issue.raw?.lowercased().contains(searchText.lowercased()) == true
		return inTitle || inId || inContent

	}


	public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		guard let cell = sender as? IssueTableViewCell else {
			preconditionFailure()
		}

		if let controller = segue.destination as? IssueDetailsTableViewController {
			controller.issue = cell.issue
		}

	}

	fileprivate func applyFilter() {
		loadInformation = false
		currentPage = 1
		hasMore = true
		loadFromServer = true

		removeAllValues()
		tableView.reloadData()

		liveScroll(valuesOf: currentPage)
	}

}

extension IssuesTableViewController: MultipleSelectionTableViewDelegate {

	public func multipleSelectionTableView(selectionTable: UITableViewController, dismissWith selected: [Any]) {

		self.status = selected as! [String]

		applyFilter()
	}

}

extension IssuesTableViewController: SingleSelectionTableViewDelegate {




	/**
     * No se evalua para el caso de RepositorySelectViewController ya que se requiere un repositorio selecionado por defecto
     */
	public func singleSelectionTableView(dismissWithClearFilter selectionTable: UITableViewController) {

		if selectionTable is UserSelectViewController {

			// si no tenia el filtro pues no pasa nada
			if assigne == nil { return }

			// si ya tenia el filtro pues se limpia y se genera la busqueda nuevamente
			assigne = nil
			applyFilter()
		}
	}



	public func singleSelectionTableView(selectionTable: UITableViewController, dismissWith selected: BasicEntity) {

		if selectionTable is RepositorySelectViewController {
			repository = selected as! Repository
			btnRepository.title = self.repository.slug!
		}

		if selectionTable is UserSelectViewController {
			assigne = selected as? Assignee
		}


		applyFilter()
	}

}

