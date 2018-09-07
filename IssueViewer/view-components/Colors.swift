//
//  Colors.swift
//  test-ios
//
//  Created by carlos chaguendo on 28/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

public struct Colors {

	public static let primary: UIColor = UIColor(named: "primary").or(else: #colorLiteral(red: 0.1254901961, green: 0.3137254902, blue: 0.5058823529, alpha: 1))
	//public static let primary: UIColor = #colorLiteral(red: 0.02745098039, green: 0.2784313725, blue: 0.6509803922, alpha: 1)


	public static let separator_color = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
	public static let status_bar: UIColor = NavBar.background
	public static let activity_indicator: UIColor = primary


	public struct Controller {
		public static let background = UIColor(named: "Controller/background").or(else: #colorLiteral(red: 0.9176470588, green: 0.9254901961, blue: 0.9411764706, alpha: 1))
	}


	public struct NavBar {
		public static let title = UIColor(named: "NavBar/title").or(else: #colorLiteral(red: 0.2588235294, green: 0.3215686275, blue: 0.431372549, alpha: 1))
		public static let buttons = UIColor(named: "NavBar/buttons").or(else: primary)
		public static let background = UIColor(named: "NavBar/background").or(else: #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.968627451, alpha: 1))
	}


	public struct TapBar {
		public static let tint = UIColor(named: "TapBar/tint").or(else: primary)
		public static let unselectedTint = UIColor(named: "TapBar/unselectedTint").or(else: #colorLiteral(red: 0.4274509804, green: 0.4470588235, blue: 0.4745098039, alpha: 1))
		public static let topBorder = UIColor(named: "TapBar/topBorder").or(else: #colorLiteral(red: 0.9137254902, green: 0.9176470588, blue: 0.9254901961, alpha: 1))
		public static let background = UIColor(named: "TapBar/background").or(else: status_bar)
	}

	public struct Cell {

		/// primario al 10%
		public static let selected = UIColor(named: "Cell/selected").or(else: #colorLiteral(red: 0.1254901961, green: 0.3137254902, blue: 0.5058823529, alpha: 0.1))
	}

}

extension UIView {

	/// Vista para las tablas selecionadas
	public static let tableViewCellSelected: UIView = TableViewCellBackgroundView()
}
