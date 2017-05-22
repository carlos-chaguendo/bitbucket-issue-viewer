//
//  LaunchScreenView.swift
//  test-ios
//
//  Created by carlos chaguendo on 16/05/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import LTMorphingLabel

class LaunchScreenView: UIViewFromXIB {

	@IBOutlet weak var titleLabel: LTMorphingLabel! {
		didSet {
			titleLabel.morphingEffect = .fall
			titleLabel.morphingDuration = 1
		}
	}


	override func awakeFromNib() {
		super.awakeFromNib()


	}



}
