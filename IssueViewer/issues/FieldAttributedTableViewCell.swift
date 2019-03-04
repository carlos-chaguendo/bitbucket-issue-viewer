//
//  FieldAttributedTableViewCell.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 24/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import CoreGraphics

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

// https://medium.freecodecamp.org/how-to-make-height-collection-views-dynamic-in-your-ios-apps-7d6ca94d2212
class AutoUpdateTextView: UITextView {

	/// constraint de altura del textView
	var heightConstraint: NSLayoutConstraint?

	override var attributedText: NSAttributedString! {
		didSet {
            //self.layoutIfNeeded()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.invalidateIntrinsicContentSize()
//            }
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
    
    func CGSizeEqualToSize(_ size1:CGSize , _ size2:CGSize ) -> Bool {
        return size1.width == size2.width && size1.height == size2.height;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !CGSizeEqualToSize(bounds.size,self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
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
