//
//  TableViewCellWithPhoto.swift
//  test-ios
//
//  Created by carlos chaguendo on 18/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

class TableViewCellWithPhoto: UITableViewCell {

	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var title: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

}
