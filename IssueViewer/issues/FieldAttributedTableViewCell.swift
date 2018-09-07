//
//  FieldAttributedTableViewCell.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 24/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit


class FieldAttributedTableViewCell: UITableViewCell {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var valueLabel: AutoUpdateTextView!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}


class AutoUpdateTextView: UITextView {

	/// constraint de altura del textView
	var heightConstraint: NSLayoutConstraint?

	override var attributedText: NSAttributedString! {
		didSet {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				self.invalidateIntrinsicContentSize()
			}
		}
	}


	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
//        isScrollEnabled = false
		isEditable = false
		dataDetectorTypes = .link
	}

	override var intrinsicContentSize: CGSize {
		return contentSize
	}

}
