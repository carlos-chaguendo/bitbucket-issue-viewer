//
//  FLAnimatedImage.swift
//  AdivantusIphone
//
//  Created by carlos chaguendo on 2/08/16.
//  Copyright © 2016 Mayorgafirm. All rights reserved.
//

import UIKit
import FLAnimatedImage
import PINRemoteImage
extension UIImageView {

	public func setImage(fromURL urlString: String?, animated: Bool = false) {

		guard let urlString = urlString else {
			return
		}


		guard let url = URL(string: urlString) else {
			return
		}

		layer.removeAllAnimations()
		pin_cancelImageDownload()
		image = nil
		(self as? FLAnimatedImageView)?.animatedImage = nil

		if !animated {
			pin_setImage(from: url)
		} else {
			pin_setImage(from: url, completion: { [weak self] result in
				guard let _self = self else { return }
				_self.alpha = 0
				UIView.transition(with: _self, duration: 0.5, options: [], animations: { () -> Void in
					_self.image = result.image
					_self.alpha = 1
				}, completion: nil)
			})
		}
	}
}
