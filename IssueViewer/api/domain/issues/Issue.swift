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

	public dynamic var assignee: Assignee?
	public dynamic var component: String?
	public dynamic var createdOn: Date?
	public dynamic var editedOn: Date?
	public dynamic var id: Int = -1
	public dynamic var kind: String?
	public dynamic var milestone: String?
	public dynamic var priority: String?
	public dynamic var reporter: Assignee?
	public dynamic var repository: Repository?
	public var state: IssueStatus?
	public dynamic var title: String?
	public dynamic var type: String?
	public dynamic var updatedOn: Date?
	public dynamic var version: String?
	public dynamic var votes: Int = 0
	public dynamic var watches: Int = 0

	//Content
	public dynamic var html: String?
	public dynamic var markup: String?
	public dynamic var raw: String?


	// Logica interna
	public dynamic var page: Int = 1
	public dynamic var _state: String? {
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
