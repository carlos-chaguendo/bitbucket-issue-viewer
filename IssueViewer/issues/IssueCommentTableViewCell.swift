//
//  IssueCommentTableViewCell.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 16/02/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

class IssueCommentTableViewCell: UITableViewCell {

	@IBOutlet weak var avatar: UIImageView!

	@IBOutlet weak var autorlabel: UILabel!

	@IBOutlet weak var dateLabel: UILabel!

	@IBOutlet weak var descriptionLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

	}

}
