//
//  Comment.swift
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

public class IssueComment: BasicEntity {

	public dynamic var id: Int = -1
	public dynamic var user: IssueUser?
	public dynamic var updatedOn: Date?
	public dynamic var createdOn: Date?

	public dynamic var html: String?
	public dynamic var markup: String?
	public dynamic var raw: String?

	public override static func primaryKey() -> String? {
		return "id"
	}


	override public func mapping(map: Map) {
		super.mapping(map: map)

		id <- map["id"]
		user <- map["user"]
		createdOn <- (map["created_on"], ISO8601ExtendedDateTransform())
		updatedOn <- (map["updated_on"], ISO8601ExtendedDateTransform())

		// content
		html <- map["content.html"]
		markup <- map["content.markup"]
		raw <- map["content.raw"]
	}
}
