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

	@objc public dynamic var id: String = "-1-"
	@objc public dynamic var user: IssueUser?
	@objc public dynamic var updatedOn: Date?
	@objc public dynamic var createdOn: Date?

	@objc public dynamic var html: String?
	@objc public dynamic var markup: String?
	@objc public dynamic var raw: String?
    @objc public dynamic var issueId:String?
    
    @objc public dynamic var changes: IssueChanges?
    
    @objc public dynamic var type:String = "issue_change"
    

	public override static func primaryKey() -> String? {
		return "id"
	}


	override public func mapping(map: Map) {
		super.mapping(map: map)

		id <- (map["id"], NumberAsStringTransform())
		user <- map["user"]
		createdOn <- (map["created_on"], ISO8601ExtendedDateTransform())
		updatedOn <- (map["updated_on"], ISO8601ExtendedDateTransform())

        type <- map["type"]
        issueId <- (map["issue.id"], NumberAsStringTransform())
        
        if type == "issue_comment" {
            // content
            html <- map["content.html"]
            markup <- map["content.markup"]
            raw <- map["content.raw"]
          
        } else {
            html <- map["message.html"]
            markup <- map["message.markup"]
            raw <- map["message.raw"]
            changes <- map["changes"]
           
        }
         changes?.id = id
        
	}
}
