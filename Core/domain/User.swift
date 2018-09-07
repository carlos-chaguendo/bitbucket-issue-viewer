//
//  User.swift
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


public class User: BasicEntity {

	public enum Origin: String {
		case user = "user"
		case team = "team"

		public func eq(_ string: String) -> Bool {
			return self.rawValue == string
		}
	}

	@objc public dynamic var username: String?
	@objc public dynamic var website: String?
	@objc public dynamic var displayName: String?
	@objc public dynamic var accountId: String?
	@objc public dynamic var avatar: String?
	@objc public dynamic var created: Date?
	@objc public dynamic var type: String?

	@objc public dynamic var numberOfmebers: String?
	@objc public dynamic var numberOfRepositories: String?


	public override static func primaryKey() -> String? {
		return "username"
	}

	override public func mapping(map: Map) {
		super.mapping(map: map)

		type <- map["type"]
		avatar <- map["links.avatar.href", nested: true]
		username <- map["username"]
		website <- map["website"]
		accountId <- map["uuid"]
		displayName <- map["display_name"]
		created <- (map["created_on"], ISO8601ExtendedDateTransform())

		avatar = avatar?.replacingOccurrences(of: "/32/", with: "/120/")
	}


	public func isType(_ type: Origin) -> Bool {
		return type.eq(self.type ?? "+")
	}
}
