//
//  TeamTableViewCell.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 21/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

	@IBOutlet weak var teamDetail: UILabel!
	@IBOutlet weak var teamSubtitle: UILabel!
	@IBOutlet weak var teamNameLabel: UILabel!
	@IBOutlet weak var avatarImage: UIImageView!

	override var textLabel: UILabel? {
		return teamNameLabel
	}

	override var detailTextLabel: UILabel? {
		return teamDetail
	}

	override var imageView: UIImageView? {
		return avatarImage
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

}
