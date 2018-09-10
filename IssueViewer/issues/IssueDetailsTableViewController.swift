//
//  IssueDetailsViewController.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import LTMorphingLabel
import IoniconsSwift
import Atributika
import Alamofire
import Core
import NYTPhotoViewer
import PINRemoteImage
import Haring

class IssueDetailsTableViewController: UITableViewController {


    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var reporterLabel: UILabel!
    @IBOutlet weak var reporterDetailLabel: LTMorphingLabel!
    @IBOutlet weak var responsibleAvatar: UIImageView!
    @IBOutlet weak var assigneeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!

    var issue: Issue?
    var team: User?
    var comments: [IssueComment] = []

    let dateFormater = DateFormatter().then {
        $0.dateFormat = "dd MMMM YYYY hh:mm"
    }

    var issueURL: String?

    fileprivate var descriptionText: NSAttributedString!
    fileprivate var attachments: [String: String] = [:]

    /// Cuando se hace pull down se evita que se coloque el color de fondo del tableView
    fileprivate let topTableLayer = CALayer()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.hidesBarsOnSwipe = false
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshComments), for: .valueChanged)
        }


        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250

        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 30;

        topTableLayer.backgroundColor = UIColor.white.cgColor
        tableView.layer.insertSublayer(topTableLayer, at: 0)

        navigationController?.hidesBarsOnSwipe = true

        assigneeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUserSelector(_:))))

        if let issue = self.issue {
            loadInformation(for: issue)
            loadComments()
        } else if let url = self.issueURL {

            let components = url.replacingOccurrences(of: "https://api.bitbucket.org/", with: "").split(separator: "/")
            let team = String(components[0])
            let repository = String(components[1])
            let id = String(components[3])

            if #available(iOS 10.0, *) {
                tableView.refreshControl?.beginRefreshing()
            }
            IssuesService.issue(id, of: team, inRepository: repository).done { (result) in

                guard let issue = result else {
                    return
                }

                self.issue = issue
                self.team = User().then({
                    $0.username = team
                })

                self.loadInformation(for: issue)
                if #available(iOS 10.0, *) {
                    self.tableView.refreshControl?.endRefreshing()
                }
                self.loadComments()

            }.catch(self.presentError)
        }


    }

    @objc func refreshComments() {
        self.comments.removeAll()
        loadComments(refreshFromServer: true)
    }

    func loadInformation(for issue: Issue) {
        self.title = "#\(issue.id)"

        titleLabel.text = issue.title
        avatarImage.setImage(fromURL: issue.reporter?.avatar)



        reporterLabel.text = issue.reporter?.displayName
        reporterDetailLabel.text = "Created at \((issue.createdOn?.relativeTime).orEmpty)"

        //descriptionText =  MarkdownParser().parse(issue.raw.orEmpty)
        descriptionText = HtmlParser.parse(html: issue.html.orEmpty)

        responsibleAvatar.setImage(fromURL: issue.assignee?.avatar)
        assigneeLabel.text = issue.assignee?.displayName
        statusLabel.text = " \(issue.state?.rawValue ?? "JUM") "


        if let state = issue.state {
            statusLabel.backgroundColor = state.color
            statusLabel.textColor = state.textColor
        }


        let priority = NSMutableAttributedString(string: String.ionicon(of: .iosArrowUp), attributes: [
            NSAttributedStringKey.foregroundColor: IssueStatus.invalid.color,
            NSAttributedStringKey.font: UIFont.ionicon(ofSize: 22)
        ])

        priority.append(NSAttributedString(string: " \(issue.priority!)"))
        priorityLabel.attributedText = priority
    }

    func loadComments(refreshFromServer: Bool = false) {
        let repository: String! = issue!.repository?.slug.orEmpty

        IssuesService.comments(of: team!.username!, inRepository: repository, forIssue: issue!.id, refreshFromServer: refreshFromServer)
            .done { (result) -> Void in

                guard let values = result?.values else {
                    self.tableView.reloadData()
                    return
                }

                values .forEach({ self.comments.append($0) })
                self.comments = self.comments.sorted(by: { $0.createdOn! < $1.createdOn! })
                self.tableView.reloadData()
                   print("poroor\n\n\n")
                print(self.comments)
                print("poroor\n\n\n")

            }.ensure {
                if #available(iOS 10.0, *) {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }.catch(execute: presentError)
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeHeaderToFit()

        topTableLayer.frame = CGRect(x: 0, y: -tableView.contentSize.height, width: tableView.frame.width, height: tableView.contentSize.height)
        topTableLayer.needsLayout()
    }

    //MARK: - Table View
    override public func numberOfSections(in tableView: UITableView) -> Int {
        if comments.count <= 0 {
            return 1
        }
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithClass(FieldAttributedTableViewCell.self)!
            cell.valueLabel.attributedText = descriptionText
            cell.valueLabel.delegate = self
            cell.selectionStyle = .none
            return cell
        }

        let cell = tableView.dequeueReusableCellWithClass(IssueCommentTableViewCell.self)!
        if let comment = comments[safe: indexPath.row] {
            cell.dateLabel.text = dateFormater.string(from: comment.createdOn.or(else: Date()))
            cell.autorlabel?.text = comment.user?.displayName
            cell.avatar.setImage(fromURL: comment.user?.avatar, animated: false)

            if let html = comment.html, html.isEmpty == false {
                if let changes = comment.changes?.html {
                    let e = "\(changes)\n\(html)"
                    cell.descriptionLabel.attributedText = HtmlParser.parse(html: e, includeAttach: true)
                }else {
                    cell.descriptionLabel.attributedText = HtmlParser.parse(html: html, includeAttach: true)
                }
            } else if let changes = comment.changes?.html {
                cell.descriptionLabel.attributedText = HtmlParser.parse(html: changes, includeAttach: true)
            } else {
                cell.descriptionLabel.text = "N?A"
            }

        }

        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "nil"
        }
        return "Comments"
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let v = view as! UITableViewHeaderFooterView
        v.backgroundView?.backgroundColor = tableView.backgroundColor
        v.backgroundView?.layer.masksToBounds = false
        v.backgroundView?.layer.shadowColor = UIColor.clear.cgColor
        v.backgroundView?.layer.shadowOpacity = 3.0
        v.backgroundView?.layer.shadowRadius = 3

        v.textLabel?.textColor = UIColor.Hex(0x205081)
        v.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        v.backgroundView?.layer.shadowOffset = CGSize(width: 0, height: 0)

    }

    @IBAction func showUserSelector(_ sender: Any) {
        print("sender \(sender)")
        guard let gesture = sender as? UITapGestureRecognizer, let v = gesture.view else {
            return
        }

        // get a reference to the view controller for the popover
        let selectviewController = Storyboard.Issues.viewControllerWithClass(UserSelectViewController.self)

        // present the popover
        var position = CGRect.zero
        position.origin.x = v.bounds.midX
        position.origin.y = v.bounds.midY + 10
        selectviewController.delegate = self

        let popController = NavigationForPopoverViewController(rootViewController: selectviewController, sourceView: v, sourceRect: position)
        self.present(popController, animated: true, completion: nil)
    }

}

extension IssueDetailsTableViewController: SingleSelectionTableViewDelegate {
    func singleSelectionTableView(selectionTable: UITableViewController, dismissWith selected: BasicEntity) {

        guard let assigne = selected as? Assignee else { return }

        IssuesService.assigne(to: assigne, issue: issue!, of: "mayorgafirm", inRepository: issue!.repository!.name!)
            .done { (edited: IssueEdited?) -> Void in
                print("Calros \(edited!)")
            }.end()

    }

}
extension IssueDetailsTableViewController: UITextViewDelegate {

    //interactua con los links dentro del textview txtViewErrors para ejecutar los segue
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {

        if let components = URLComponents(url: URL, resolvingAgainstBaseURL: false)?.queryItems?.groupBy({ $0.name }) {
            if components["issue-id"] != nil {
                let issue = Storyboard.Issues.viewControllerWithClass(IssueDetailsTableViewController.self)
                issue.issueURL = URL.absoluteString
                navigationController?.pushViewController(issue, animated: true)
                return false
            }

        }

        if UIApplication.shared.canOpenURL(URL) == false {
            return false
        }

        let g = GrantAccesViewController()
        let nav = UINavigationController(rootViewController: g)

        present(nav, animated: true) {
            g.webView.load(URLRequest(url: URL))
        }
        return false
    }
}




