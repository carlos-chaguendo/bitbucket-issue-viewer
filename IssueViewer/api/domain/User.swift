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

	public dynamic var username: String?
	public dynamic var website: String?
	public dynamic var displayName: String?
	public dynamic var accountId: String?
	public dynamic var created: Date?

	public override static func primaryKey() -> String? {
		return "username"
	}

	override public func mapping(map: Map) {
		super.mapping(map: map)

		username <- map["username"]
		website <- map["website"]
		accountId <- map["account_id"]
		displayName <- map["display_name"]
		created <- (map["created_on"], ISO8601ExtendedDateTransform())
	}

}
