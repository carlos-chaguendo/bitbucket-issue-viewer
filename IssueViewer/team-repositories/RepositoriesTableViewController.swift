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

class RepositoriesTableViewController: LiveScrollTableViewController {


    var user: User!

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        tabBarController?.tabBar.tintColor = Colors.TapBar.tint
        tabBarController?.tabBar.barTintColor = Colors.TapBar.background

        UIApplication.shared.statusBarView?.backgroundColor = Colors.status_bar
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default


        (tabBarController as! HomeTabBarController).tabBarTopBorder.backgroundColor = Colors.TapBar.topBorder.cgColor
        self.navigationController?.hidesBarsOnSwipe = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tabBarController?.tabBar.tintColor = UIColor.white
        tabBarController?.tabBar.barTintColor = Colors.primary

        UIApplication.shared.statusBarView?.backgroundColor = Colors.primary
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        (tabBarController as! HomeTabBarController).tabBarTopBorder.backgroundColor = UIColor.Hex(0x42526e).cgColor


        tabBarController?.tabBar.isHidden = false


        self.navigationController?.setNavigationBarHidden(true, animated: animated)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.hidesBarsOnSwipe = false

        self.navigationController?.setToolbarHidden(true, animated: false)
    }

    @objc override func viewDidLoad() {


        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.rowHeight = 98 //UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        tableView.separatorColor = UIColor.clear

        refreshControl?.tintColor = UIColor.white
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.isHidden = true


        if Device.userInterfaceIdiom == .pad {
            let margin = UITableViewController().tableView.layoutMargins.left
            tableView.layoutMargins.left = margin
            tableView.layoutMargins.right = margin
        }

        super.viewDidLoad()
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
