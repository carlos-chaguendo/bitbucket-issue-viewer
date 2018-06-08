//
//  Assignee.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class Assignee: BasicEntity {

	@objc public dynamic var displayName: String?
	@objc public dynamic var type: String?
	@objc public dynamic var username: String?
	@objc public dynamic var uuid: String?
	@objc public dynamic var avatar: String?

	public override static func primaryKey() -> String? {
		return "uuid"
	}

	override public func mapping(map: Map) {
		super.mapping(map: map)
		displayName <- map["display_name"]
		type <- map["type"]
		username <- map["username"]
		uuid <- map["uuid"]
		avatar <- map["links.avatar.href"]
	}

}
