//
//  Issue.swift
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

public class Issue: BasicEntity {

	@objc public dynamic var assignee: Assignee?
	@objc public dynamic var component: String?
	@objc public dynamic var createdOn: Date?
	@objc public dynamic var editedOn: Date?
	@objc public dynamic var id: Int = -1
	@objc public dynamic var kind: String?
	@objc public dynamic var milestone: String?
	@objc public dynamic var priority: String?
	@objc public dynamic var reporter: Assignee?
	@objc public dynamic var repository: Repository?
	public var state: IssueStatus?
	@objc public dynamic var title: String?
	@objc public dynamic var type: String?
	@objc public dynamic var updatedOn: Date?
	@objc public dynamic var version: String?
	@objc public dynamic var votes: Int = 0
	@objc public dynamic var watches: Int = 0

	//Content
	@objc public dynamic var html: String?
	@objc public dynamic var markup: String?
	@objc public dynamic var raw: String?


	// Logica interna
	@objc public dynamic var page: Int = 1
	@objc public dynamic var _state: String? {
		didSet {
			state = IssueStatus(rawValue: _state ?? "s")
		}
	}


	public override static func primaryKey() -> String? {
		return "id"
	}


	override public func mapping(map: Map) {
		super.mapping(map: map)
		assignee <- map["assignee"]
		component <- map["component.name"]
		createdOn <- (map["created_on"], ISO8601ExtendedDateTransform())
		editedOn <- (map["edited_on"], ISO8601ExtendedDateTransform())
		id <- map["id"]
		kind <- map["kind"]
		milestone <- map["milestone"]
		priority <- map["priority"]
		reporter <- map["reporter"]
		repository <- map["repository"]
		state <- (map["state"], EnumTransform())
		title <- map["title"]
		type <- map["type"]
		updatedOn <- ( map["updated_on"], ISO8601ExtendedDateTransform())
		version <- map["version.name"]
		votes <- map["votes"]
		watches <- map["watches"]

		// content
		html <- map["content.html"]
		markup <- map["content.markup"]
		raw <- map["content.raw"]

		if map.mappingType == .fromJSON {
			_state = state?.rawValue
		}
	}

}
