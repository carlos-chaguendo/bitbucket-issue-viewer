//
//  SimpleUser.swift
//  test-ios
//
//  Created by carlos chaguendo on 26/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class SimpleUser: BasicEntity {

	public dynamic var username: String?
	public dynamic var displayName: String?
	public dynamic var uuid: String?

	public override static func primaryKey() -> String? {
		return "uuid"
	}

	override public func mapping(map: Map) {
		super.mapping(map: map)
		username <- map["username"]
		displayName <- map["display_name"]
		uuid <- map["uuid"]
	}

}

