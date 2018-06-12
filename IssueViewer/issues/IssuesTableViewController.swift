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
import PromiseKit
import SwipeCellKit
import Core

public class IssuesTableViewController: LiveScrollTableViewController {

    @IBOutlet weak var search: UIBarButtonItem!
    @IBOutlet weak var btnRepository: UIBarButtonItem!


    fileprivate var assigne: Assignee?
    fileprivate var repository: Repository!
    fileprivate var status = [String]()
    fileprivate var currentRequest: Promise<SearchResult<Issue>?>?

    public var team: User!

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false
    }

    override public func viewDidLoad() {




        if let filters = TeamsService.currentFilters(of: team) {
            print("Llenando filtros actuales")
            // filtros actuales
            repository = filters.repository
            status = (filters.status.orEmpty).components(separatedBy: ",")
            assigne = filters.assigne
            btnRepository.title = repository.slug
        }


        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
    }

    /**
     * Se encarga de determinar cual es el repositorio actualmente seleccionado,
     * Si no existe ninguno carga el primero del grupo
     */
    private func resolveCurrentFilters() -> Promise<Void> {
        return Promise<Void> { (resolve, reject) -> Void in

            if self.repository == nil {

                print("Cargando repositorios de la nuve ")
                RepositoryService.repositories(for: team.username!)
                    .then (execute: { (searchResult) -> Void in

                        if searchResult?.size ?? 0 <= 0 {
                            reject(LiveScrollError.cantNotLoadInformation("Not repositories whit issues"))
                            return
                        }

                        self.status = ["new", "close", "open"]
                        self.repository = searchResult?.values[0]

                        self.btnRepository.title = self.repository.slug!
                        resolve(())

                    }).end()
                return
            }

            resolve(())
            }
        }


        /**
     * Metodo llamado cuando se realiza un avance de pagina mediante el scroll
     */
        override public func liveScroll(valuesOf page: Int) {

            resolveCurrentFilters()
                .then(execute: { () -> Void in

                    self.currentRequest = IssuesService.issues(of: self.team, inRepository: self.repository, assigneedTo: self.assigne, whitStatus: self.status, page: page, refreshFromServer: self.loadFromServer)
                    self.currentRequest!.then (execute: { (result) -> Void in

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
                    }).always (execute: {
                        self.loadInformation = true;
                        self.refreshControl?.endRefreshing()
                        self.currentRequest = nil

                    }).catch (execute: self.presentError)

                }).catch(execute: markAsEmptyTable)
        }

        @IBAction func showRepositorySelector(_ sender: UIBarButtonItem) {


            // get a reference to the view controller for the popover
            let selectviewController = Storyboard.Issues.viewControllerWithClass(RepositorySelectViewController.self)
            selectviewController.delegate = self
            selectviewController.repository = repository
            selectviewController.team = team

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

            cell.delegate = self
            cell.issue = issue
            return cell
        }


        override public func searchController(searchText: String, in value: AnyObject) -> Bool {
            guard let issue = value as? Issue else { return false }

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

                guard let issue = self.values[safe: indexPath.row] as? Issue else {
                    return
                }

                let assigne = Assignee();
                assigne.username = "pruebasMayorgafirm"
                IssuesService.assigne(to: assigne, issue: issue, of: "mayorgafirm", inRepository: issue.repository!.name!)
                    .then { (edited: IssueEdited?) -> Void in
                        UIApplication.shared.keyWindow?.makeToast("Enviado a q \(issue.id)")
                    }.end()
            }
            sendQAAction.backgroundColor = Colors.primary
            return [sendQAAction]
        }
    }

