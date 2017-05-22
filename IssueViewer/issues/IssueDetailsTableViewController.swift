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

class IssueDetailsTableViewController: UITableViewController {


	@IBOutlet weak var headerView: UIView!
//
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var avatarImage: UIImageView!
	@IBOutlet weak var reporterLabel: UILabel!
	@IBOutlet weak var reporterDetailLabel: LTMorphingLabel!
	@IBOutlet weak var issueDescriptionLabel: UILabel!
	@IBOutlet weak var responsibleAvatar: UIImageView!
	@IBOutlet weak var assigneeLabel: UILabel!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var priorityLabel: UILabel!

	var issue: Issue?
	var comments: [IssueComment] = []

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.setToolbarHidden(true, animated: true)
		navigationController?.hidesBarsOnSwipe = false
	}



	override func viewDidLoad() {
		super.viewDidLoad()


		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 250

		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.estimatedSectionHeaderHeight = 30;


		navigationController?.hidesBarsOnSwipe = true



		assigneeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showUserSelector(_:))))


		guard let issue = self.issue else {
			preconditionFailure()
		}

		navigationItem.title = "#\(issue.id)"

		titleLabel.text = issue.title
//        https://d301sr5gafysq2.cloudfront.net/60b56f726b78/img/default_avatar/user_blue.svg
		avatarImage.setImage(fromURL: issue.reporter?.avatar)



		reporterLabel.text = issue.reporter?.displayName
		reporterDetailLabel.text = "Created at \(issue.createdOn?.relativeTime ?? "")"
		issueDescriptionLabel.text = issue.raw

		updateTableViewHeaderViewHeight()

		responsibleAvatar.setImage(fromURL: issue.assignee?.avatar)
		assigneeLabel.text = issue.assignee?.displayName
		statusLabel.text = " \(issue.state?.rawValue ?? "JUM") "


		if let state = issue.state {
			statusLabel.backgroundColor = state.color
			statusLabel.textColor = state.textColor
		}


		let priority = NSMutableAttributedString(string: String.ionicon(of: .iosArrowUp), attributes: [
			NSForegroundColorAttributeName: IssueStatus.invalid.color,
			NSFontAttributeName: UIFont.ionicon(ofSize: 22)
		])

		priority.append(NSAttributedString(string: " \(issue.priority!)"))
		priorityLabel.attributedText = priority

		IssuesService.comments(of: "mayorgafirm", inRepository: "adivantus-iphone", forIssue: issue.id)
			.then { (result) -> Void in

				guard let values = result?.values else {
					return
				}

				values .forEach({ self.comments.append($0) })

				self.tableView.reloadData()

			}.always {

			}.catch(execute: presentError)

	}




	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comments.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = UITableViewCell()
		if let comment = comments[safe: indexPath.row] {
			cell.textLabel?.text = comment.raw
			cell.textLabel?.numberOfLines = 0
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Comments"
	}

	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

		let v = view as! UITableViewHeaderFooterView
		v.backgroundView?.backgroundColor = UIColor.Hex(0xeeeeee)
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


		let popController = NavigationForPopoverViewController(rootViewController: selectviewController, sourceView: v, sourceRect: position)
		self.present(popController, animated: true, completion: nil)
	}




}
