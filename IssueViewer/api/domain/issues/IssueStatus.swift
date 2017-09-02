//
//  IssueStatus.swift
//  test-ios
//
//  Created by carlos chaguendo on 26/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit

public enum IssueStatus: String {

    case wontfix = "wontfix"
    case invalid = "invalid"
    case new = "new"
    case closed = "closed"
    case resolved = "resolved"
    case on_hold = "on hold"
    case open = "open"
    case none = ""

    var color: UIColor {
        get {
            switch self {
            case .wontfix: return UIColor.Hex(0xd04437);
            case .invalid: return UIColor.Hex(0xd04437);
            case .new: return UIColor.Hex(0x205081)
            case .closed: return UIColor.Hex(0x14892c)
            case .resolved: return UIColor.Hex(0x14892c)
            case .on_hold: return UIColor.Hex(0xf6c342)
            case .open: return UIColor.Hex(0x333333)
            case .none: return UIColor.Hex(0xCCCFFF)
            }
        }
    }

    var textColor: UIColor {
        get {
            switch self {
            case .on_hold: return UIColor.Hex(0x594300)
            case .open: return UIColor.Hex(0xCCCCCC)
            default: return UIColor.Hex(0xffffff)
            }
        }
    }





}
