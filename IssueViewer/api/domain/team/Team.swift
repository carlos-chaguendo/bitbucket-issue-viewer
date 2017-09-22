//
//  Team.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 20/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class Team: BasicEntity {

    public dynamic var username: String?
    public dynamic var website: String?
    public dynamic var displayName: String?
    public dynamic var uuid: String?
    public dynamic var avatar: String?

    public dynamic var numberOfmebers: String?
    public dynamic var numberOfRepositories: String?

    public override static func primaryKey() -> String? {
        return "uuid"
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        avatar <- map["links.avatar.href", nested: true]
        displayName <- map["display_name"]
        username <- map["username"]
        website <- map["website"]
        uuid <- map["uuid"]
    }

}
