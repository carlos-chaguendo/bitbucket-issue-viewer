//
//  IssueTableViewCell.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

public class IssueTableViewCell: UITableViewCell {

	@IBOutlet weak private var idLabel: UILabel!
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var descriptionLabel: UILabel!

	@IBOutlet weak var avatar: UIImageView!

	public var issue: Issue? {
		didSet {
			idLabel.text = "#\(issue?.id ?? 0)"
			titleLabel.text = issue?.title

			avatar.setImage(fromURL: issue?.assignee?.avatar)


			let description = NSMutableAttributedString()

			// Segun el estado en que se encuentre el issue se fija un color diferente
			if let state = issue?.state {

				description.append(NSAttributedString(string: state.rawValue, attributes: [
					NSForegroundColorAttributeName: state.color,
					NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)]
				))
			}
			// El nombre de la persona aignada
			description.append(NSAttributedString(string: " • \(issue?.assignee?.displayName ?? "") • "))

			// La fecha de ultima modificacion
			description.append(NSAttributedString(string: (issue?.updatedOn ?? issue!.createdOn!).relativeTime))
			descriptionLabel.attributedText = description

		}

	}


	override public func awakeFromNib() {
		super.awakeFromNib()
	}

	override public func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

}
