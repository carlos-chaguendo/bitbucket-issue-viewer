//
//  SettingsViewController.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 20/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit
import IoniconsSwift
import Core

public class SettingsViewController: UITableViewController {

    private enum Row {
        case logout
        case gestureLeft
        case gestureRight
    }

    private enum Section {
        case logout([Row])
        case gesture([Row])
    }


    private var sections: [Section] = []

    //MARK: - live
    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = false
        tableView.registerWithClass(UITableViewCell.self)
        sections.append(.gesture([.gestureLeft, .gestureRight]))
        sections.append(.logout([.logout]))
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    //MARK: - Table View Datasource
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    override public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = tableView.backgroundColor
            header.textLabel?.textColor = #colorLiteral(red: 0.1254901961, green: 0.3137254902, blue: 0.5058823529, alpha: 1)
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .logout(let rows), .gesture(let rows):
            return rows.count
        }
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.section] {
        case .logout(let rows), .gesture(let rows):
            switch rows[indexPath.row] {
            case .logout:
                let cell = tableView.dequeueReusableCellWithClass(UITableViewCell.self)!
                cell.textLabel?.textColor = #colorLiteral(red: 0.8156862745, green: 0.2666666667, blue: 0.2156862745, alpha: 1)
                cell.textLabel?.text = "Sing Out"
                cell.selectionStyle = .none
                cell.accessoryType = .none
                cell.selectedBackgroundView = .tableViewCellSelected
                return cell

            case .gestureLeft:
                let cell = tableView.dequeueReusableCellWithClass(UITableViewCell.self)!
                cell.textLabel?.textColor = #colorLiteral(red: 0.1411764706, green: 0.2156862745, blue: 0.3490196078, alpha: 1)
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
                cell.textLabel?.text = "Left Action"
                cell.accessoryType = .disclosureIndicator
                      cell.selectedBackgroundView = .tableViewCellSelected
                return cell
            case .gestureRight:
                let cell = tableView.dequeueReusableCellWithClass(UITableViewCell.self)!
                 cell.textLabel?.textColor = #colorLiteral(red: 0.1411764706, green: 0.2156862745, blue: 0.3490196078, alpha: 1)
                cell.textLabel?.text = "Right Action"
                cell.accessoryType = .disclosureIndicator
                      cell.selectedBackgroundView = .tableViewCellSelected
                return cell
            }
        }
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .logout(let rows), .gesture(let rows):
            switch rows[indexPath.row] {
            case .logout:

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    print("Not found app.delegate")
                    return
                }


                let alert = UIAlertController(title: "Are you sure?", message: "All of your accounts will be signed out. Do you want to continue?", preferredStyle: .alert).then {
                    $0.add(UIAlertAction(title: "Cancel", style: .cancel))
                    $0.add(UIAlertAction(title: "Sing Out", style: .destructive) { _ in
                        SessionService.logout().done {
                            appDelegate.showLoginView()
                        }.end()
                    })
                }


                self.present(alert, animated: true)

                print("Logiout")
            case .gestureLeft:
                print("Nada")
            case .gestureRight:
                print("Nada")
            }
        }
    }



}
