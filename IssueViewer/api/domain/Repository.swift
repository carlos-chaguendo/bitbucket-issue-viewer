//
//  Repository.swift
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


public class Repository: BasicEntity {

	public dynamic var fullName: String?
	public dynamic var name: String?
	public dynamic var type: String?
	public dynamic var uuid: String?
	public dynamic var slug: String?
	public var has_issues: Bool = false


	public override static func primaryKey() -> String? {
		return "uuid"
	}

	override public func mapping(map: Map) {

		fullName <- map["full_name"]
		name <- map["name"]
		type <- map["type"]
		uuid <- map["uuid"]
		slug <- map["slug"]
		has_issues <- map["has_issues"]

	}

}
