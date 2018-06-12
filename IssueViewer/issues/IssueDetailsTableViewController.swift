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

class IssueDetailsTableViewController: UITableViewController {


	@IBOutlet weak var headerView: UIView!
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
    let dateFormater = DateFormatter()
    
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

        dateFormater.dateFormat = "dd MMMM YYYY hh:mm"

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

		guard let issue = self.issue else {
			preconditionFailure()
		}

		self.title = "#\(issue.id)"

		titleLabel.text = issue.title
		avatarImage.setImage(fromURL: issue.reporter?.avatar)



		reporterLabel.text = issue.reporter?.displayName
		reporterDetailLabel.text = "Created at \((issue.createdOn?.relativeTime).orEmpty)"
        
        let em = Style("em").font(.boldSystemFont(ofSize: 17)).foregroundColor(Colors.primary)
        let strong = Style("strong").font(.boldSystemFont(ofSize: 17)).foregroundColor(Colors.primary)

        let p = Style("p").baselineOffset(5)
        let final = Style("final").baselineOffset(5).font(.boldSystemFont(ofSize: 10)).foregroundColor(Colors.primary.withAlphaComponent(0.6))

        
        
        
        let str = "\((issue.html.or(else: "N/A"))) \n\n <final>Final del contenido</final> \n\n\n\n".style(tags: [em,strong,p,final])
            .styleAll(Style.font(.systemFont(ofSize: 14)))
            .attributedString
    
        
		issueDescriptionLabel.attributedText = str
        

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

       loadComments()

	}
    
    @objc func refreshComments(){
        self.comments.removeAll()
        loadComments(refreshFromServer: true)
    }
    
    func loadComments(refreshFromServer:Bool = false){
        
        let repository:String! = issue!.repository?.slug.orEmpty
        IssuesService.comments(of: "mayorgafirm", inRepository: repository, forIssue: issue!.id , refreshFromServer: refreshFromServer)
            .then { (result) -> Void in
                
                guard let values = result?.values else {
                    self.tableView.reloadData()
                    return
                }
                
                values .forEach({ self.comments.append($0) })
                self.comments = self.comments.sorted(by: { $0.createdOn! > $1.createdOn! })
                self.tableView.reloadData()
                
            }.always {
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

    override public func numberOfSections(in tableView: UITableView) -> Int {
        if comments.count <= 0 {
            return 0
        }
        return 1
    }
    

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
		return comments.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithClass(IssueCommentTableViewCell.self)!
		if let comment = comments[safe: indexPath.row] {
            cell.dateLabel.text = dateFormater.string(from: comment.createdOn.or(else: Date()))
//            cell.avatar.setImage(fromURL: comment.user?.avatar)
            cell.autorlabel?.text = comment.user?.displayName
            cell.descriptionLabel.text = comment.raw.or(else: "Status Change")!
		}

        cell.selectionStyle = .none
        cell.backgroundColor = .clear
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
		v.backgroundView?.backgroundColor =  tableView.backgroundColor
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

extension IssueDetailsTableViewController: SingleSelectionTableViewDelegate{
    func singleSelectionTableView(selectionTable: UITableViewController, dismissWith selected: BasicEntity) {
        
        guard let assigne = selected as? Assignee else {return}
        
//        
        IssuesService.assigne(to: assigne, issue: issue!, of: "mayorgafirm", inRepository: issue!.repository!.name!)
            .then { (edited:IssueEdited?) -> Void in
            
                
                print("Calros \(edited!)")
           
        }.end()
//
    }
    
}
