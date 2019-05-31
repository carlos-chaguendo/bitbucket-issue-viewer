//
//  LiveScrollTableViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 21/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import PromiseKit
import NVActivityIndicatorView
import Core

public enum LiveScrollError: Error {
    case cantNotLoadInformation(String)
}

public class LiveScrollTableViewController<Element>: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    public var values: FiltrableArray<Element> = []

    public func removeAllValues() {
        values.removeAll(keepingCapacity: false)
    }

    public func appendValues(_ values: [Element]) {
        self.values.append(values)
    }

    // pagination
    public var currentPage = 1
    public var hasMore = true
    public var loadInformation = false
    public var loadFromServer = false
    public var refreshActivitiIndicator: NVActivityIndicatorView?

    // Promise<SearchResult<Repository>?>
    public func liveScroll(valuesOf page: Int) {
        preconditionFailure()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()

        if let refresh = refreshControl {
            let frame = refresh.frame
            let activity = NVActivityIndicatorView(frame: frame, type: .ballScaleMultiple, color: Colors.activity_indicator)
//			refresh.addSubview(activity)
            refresh.tintColor = Colors.primary
            activity.startAnimating()
            refresh.addTarget(self, action: #selector(self.loadValuesFromServer), for: UIControl.Event.valueChanged)

            refreshActivitiIndicator = activity
        }


        loadValues()
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        hideSearchBar()
    }



    @objc private func loadValuesFromServer() {
        currentPage = 1
        loadFromServer = true
        liveScroll(valuesOf: currentPage)
    }


    private func loadValues() {
        liveScroll(valuesOf: currentPage)
    }


    public func markAsEmptyTable(cause error: Error) {
        Logger.info("Error resolve de reisnte")

        loadInformation = true;
        removeAllValues()
        hasMore = false
        appendValues([])
        loadFromServer = false
        refreshControl?.endRefreshing()
        tableView.reloadData()


        guard let liveError = error as? LiveScrollError else {
            return
        }

        if case let .cantNotLoadInformation(message) = liveError {
            let label = UILabel(frame: tableView.frame)
            label.textAlignment = .center
            label.textColor = Colors.primary
            label.text = message
            tableView.backgroundView = label
        }

    }

    override public func numberOfSections(in tableView: UITableView) -> Int {


        if !loadInformation {

            let view = UIView()
            tableView.backgroundView = view


            let frame = CGRect(x: view.center.x - 20, y: view.center.y - 20, width: 40, height: 40);
            let activity = NVActivityIndicatorView(frame: frame, type: .ballScale, color: Colors.activity_indicator)
            activity.startAnimating()
            view.addSubview(activity)

            tableView.separatorStyle = .none
            return 0
        }

        if values.count <= 0 {

            let label = UILabel(frame: tableView.frame)
            label.textAlignment = .center
            label.text = String.ionicon(of: Ionicons.merge)
            label.font = UIFont.ionicon(ofSize: 40)
            label.textColor = Colors.primary

            tableView.backgroundView = label
            tableView.backgroundColor = Colors.Controller.background
            return 0
        }

        view.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.backgroundView = nil
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let lastRow = self.values.count - 1
        if indexPath.row == lastRow {
            currentPage += 1
            if hasMore {
                loadValues()
            }
        }

    }




    // MARK: - Search

    let searchController = UISearchController(searchResultsController: nil)

    func setupSearchController() {

        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = Colors.NavBar.background
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = Colors.primary

    }

    func showSearchBar() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        searchController.searchBar.isHidden = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
    }

    func hideSearchBar() {
        searchController.dismiss(animated: true) {

        }
        searchController.searchBar.isHidden = true
        tableView.tableHeaderView = nil
        searchController.searchBar.endEditing(true)
    }

    func searchController(searchText: String, in value: Element) -> Bool {
        preconditionFailure()
    }

    fileprivate func filterContentForSearchText(_ searchText: String) {
        values.setFilter({ (value: Element) -> Bool in
            return self.searchController(searchText: searchText, in: value)
        })
        self.tableView.reloadData()
    }

    // MARK: - UISearchBar Delegate
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }



    // MARK: - UISearchResultsUpdating Delegate
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)

    }
}

