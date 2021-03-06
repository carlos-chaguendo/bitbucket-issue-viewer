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
import PromiseKit
import SwipeCellKit
//import Material
import Core

public class IssuesTableViewController: LiveScrollTableViewController<Issue> {

    @IBOutlet weak var search: UIBarButtonItem!
    @IBOutlet weak var btnRepository: UIBarButtonItem!

    fileprivate var assigne: Assignee?
    fileprivate var repository: Repository!
    fileprivate var status = [String]()
    fileprivate var currentRequest: Promise<SearchResult<Issue>?>?

    public var team: User!


    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false
    }

    override public func viewDidLoad() {


        if let filters = TeamsService.currentFilters(of: team) {
            Logger.info("Llenando filtros actuales")
            // filtros actuales
            repository = filters.repository
            status = (filters.status.orEmpty).components(separatedBy: ",")
            assigne = filters.assigne
            btnRepository.title = repository.slug
        }


        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250

        if UIDevice.current.userInterfaceIdiom == .pad {
            let margin = UITableViewController().tableView.layoutMargins.left
            tableView.layoutMargins.left = margin
            tableView.layoutMargins.right = margin
        }
    }

    /**
     * Se encarga de determinar cual es el repositorio actualmente seleccionado,
     * Si no existe ninguno carga el primero del grupo
     */
    private func resolveCurrentFilters() -> Promise<Void> {
        return Promise<Void> { seal in

            if self.repository == nil {

                Logger.info("Cargando repositorios de la nuve ")
                RepositoryService.repositories(for: team.username!)
                    .done { (searchResult) -> Void in

                        if searchResult?.size ?? 0 <= 0 {
                            seal.reject(LiveScrollError.cantNotLoadInformation("Not repositories whit issues"))
                            return
                        }

                        self.status = ["new", "close", "open"]
                        self.repository = searchResult?.values[0]

                        self.btnRepository.title = self.repository.slug!
                        seal.fulfill(())

                    }.end()
                return
            }

            seal.fulfill(())
        }
    }


    /**
     * Metodo llamado cuando se realiza un avance de pagina mediante el scroll
     */
    override public func liveScroll(valuesOf page: Int) {

        resolveCurrentFilters()
            .done { () -> Void in

                self.currentRequest = IssuesService.issues(of: self.team, inRepository: self.repository, assigneedTo: self.assigne, whitStatus: self.status, page: page, refreshFromServer: self.loadFromServer)
                self.currentRequest!.done { (result) -> Void in

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
                    self.loadFromServer = false
                    self.tableView.reloadData()
                }.ensure {
                    self.loadInformation = true;
                    self.refreshControl?.endRefreshing()
                    self.currentRequest = nil

                }.catch (execute: self.presentError)

            }.catch(execute: markAsEmptyTable)
    }

    @IBAction func showRepositorySelector(_ sender: UIBarButtonItem) {


        // get a reference to the view controller for the popover
        let selectviewController = Storyboard.Issues.viewControllerWithClass(RepositorySelectViewController.self)
        selectviewController.promise.done { (result) in
            if let repo = result {
                self.repository = repo
                self.btnRepository.title = self.repository.slug!
                self.applyFilter()
            }
        }.end()
        
        selectviewController.repository = repository
        selectviewController.team = team

        // present the popover
        let popController = NavigationForPopoverViewController(rootViewController: selectviewController,  barButtonItem: sender )

        self.present(popController, animated: true, completion: nil)
    }

    @IBAction func showUserSelector(_ sender: UIBarButtonItem) {
        // get a reference to the view controller for the popover
        let selectviewController = Storyboard.Issues.viewControllerWithClass(UserSelectViewController.self)
        selectviewController.user = assigne
        selectviewController.promise.done { (result) in
            self.assigne = result
            self.applyFilter()
        }.end()

        // present the popover
        let popController = NavigationForPopoverViewController(rootViewController: selectviewController, barButtonItem: sender )
        self.present(popController, animated: true, completion: nil)
    }


    @IBAction func showStatusSelector(_ sender: UIBarButtonItem) {
        // get a reference to the view controller for the popover
        let selectviewController = StatusSelectViewController()
        selectviewController.status = self.status
        selectviewController.promise.done { (result) in
            self.status = result
            self.applyFilter()
        }.end()

        // present the popover

        let popController = NavigationForPopoverViewController(rootViewController: selectviewController, barButtonItem: sender )
        self.present(popController, animated: true, completion: nil)
    }




    @IBAction func searchAction(_ sender: UIBarButtonItem) {
        showSearchBar()
    }


    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "issueViewCell", for: indexPath) as? IssueTableViewCell else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: "defaultCell")
        }

        guard let issue = values[safe: indexPath.row] else {
            return cell
        }

        cell.delegate = self
        cell.issue = issue
        return cell
    }


    override public func searchController(searchText: String, in value: Issue) -> Bool {
        let issue = value
        let inTitle = issue.title?.lowercased().contains(searchText.lowercased()) == true
        let inId = "#\(issue.id)".starts(with: searchText.lowercased()) == true
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
            controller.team = team
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


//MARK: - Swipe Table View Cell Delegate
extension IssuesTableViewController: SwipeTableViewCellDelegate {


    public func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        return options
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let sendQAAction = SwipeAction(style: .default, title: "Send to QA") { action, indexPath in

            guard let selected = self.values[safe: indexPath.row] else {
                return
            }
   

            let qauser = Assignee();
            qauser.username = "pruebasMayorgafirm"
            IssuesService.assigne(to: qauser, issue: selected )
                .done { edited in
                    UIApplication.shared.keyWindow?.makeToast("Enviado a q \(selected.id)")
                }.catch(self.presentError)
        }
        sendQAAction.backgroundColor = Colors.primary
        return [sendQAAction]
    }
}

