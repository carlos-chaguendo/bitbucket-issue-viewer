//
//  UIViewController+Apparence.swift
//  test-ios
//
//  Created by carlos chaguendo on 19/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import ToastSwiftFramework


/**
 *
 */
extension UIImagePickerController {
	override open func viewDidLoad() {
		super.viewDidLoad()
	}
}



/**
 *
 */
extension UIViewController {
    
    var viewForToast: UIView {
        return (self.tabBarController?.view ?? self.navigationController?.view ?? self.view)!
    }

	func presentError(_ error: Error) -> Void {

		func showLocalizedDescription(_ nserror: Error) {
			if let description = (nserror as NSError?)?.localizedDescription {
				var style = ToastStyle()
				// style.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
				style.verticalPadding = 5.0
				self.viewForToast.makeToast("\(description)", duration: 5.0, position: .bottom, style: style)
			}
		}

		showLocalizedDescription(error)


	}

	func alertInformation(_ title: String, message: String, handler: @escaping (() -> Void)) {

		let buttonsHandler: (UIAlertAction) -> Void = { action in
			switch action.style {
			case .default: handler()
			default: break
			}
		}

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: buttonsHandler))
		self.present(alert, animated: true, completion: nil)

	}
}

extension UITableViewController {

	override open func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Colors.Controller.background
	}


	func updateTableViewHeaderViewHeight() {
        tableView.sizeHeaderToFit()
	}
}

extension UIApplication {
	var statusBarView: UIView? {
		return value(forKey: "statusBar") as? UIView
	}
}

extension UINavigationController {
	open override func viewDidLoad() {
		super.viewDidLoad()
		hidesBarsOnSwipe = true
	}
}

//
//class ViewController: UIViewController {
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		view.backgroundColor = UIColor.Hex(0xeeeeee)
//	}
//
//}

extension UINavigationItem {

	func setTitle(_ title: String, subtitle: String) {
		let label = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: 50.0, height: 40.0))

		label.font = UIFont.boldSystemFont(ofSize: 17.0)
		label.numberOfLines = 2
		label.text = "\(title)\n\(subtitle)"

		label.textColor = Colors.NavBar.title
		label.sizeToFit()
		label.textAlignment = NSTextAlignment.center



		let titleString = NSMutableAttributedString(string: title)
		let subtitleString = NSMutableAttributedString(string: subtitle, attributes: [
			NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12.5),
			NSAttributedStringKey.foregroundColor: Colors.NavBar.title.withAlphaComponent(0.6)
		])


		titleString.append(NSMutableAttributedString(string: "\n"))
		titleString.append(subtitleString)

		label.attributedText = titleString

		self.titleView = label
	}

}







