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
    case onHold = "on hold"
    case open = "open"
    case none = ""

    public var color: UIColor {
        switch self {
        case .wontfix: return UIColor.hex(0xd04437)
        case .invalid: return UIColor.hex(0xd04437)
        case .new: return UIColor.hex(0x205081)
        case .closed: return UIColor.hex(0x14892c)
        case .resolved: return UIColor.hex(0x14892c)
        case .onHold: return UIColor.hex(0xf6c342)
        case .open: return UIColor.hex(0x333333)
        case .none: return UIColor.hex(0xCCCFFF)
        }
    }

    public var textColor: UIColor {
        switch self {
        case .onHold: return UIColor.hex(0x594300)
        case .open: return UIColor.hex(0xCCCCCC)
        default: return UIColor.hex(0xffffff)
        }
    }
}
