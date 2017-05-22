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

	public dynamic var displayName: String?
	public dynamic var type: String?
	public dynamic var username: String?
	public dynamic var uuid: String?
	public dynamic var avatar: String?

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
