//
//  UIPopoverPresentationController.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 13/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

extension UIPopoverPresentationController {
    
    var dimmingView: UIView? {
        return value(forKey: "_dimmingView") as? UIView
    }
    
}
