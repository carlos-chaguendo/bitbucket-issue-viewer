//
//  IssueUser.swift
//  test-ios
//
//  Created by carlos chaguendo on 26/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import ObjectMapper
import UIKit

public class IssueUser: SimpleUser {

    @objc public dynamic var avatar: String?

    override public func mapping(map: Map) {
        super.mapping(map: map)
        avatar <- map["links.avatar.href"]
    }
}
