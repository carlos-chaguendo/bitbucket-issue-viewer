//
//  TeamMebers.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 21/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class TeamMember: BasicEntity {

    @objc public dynamic var team: User?
    @objc public dynamic var user: User?
    @objc public dynamic var id: String?

    public override static func primaryKey() -> String? {
        return "id"
    }

    public convenience init(user: User, team: User) {
        self.init()
        self.user = user
        self.team = team
        id = "\(user.accountId ?? "-1")\(team.accountId ?? "-2")"
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)
        team <- map["team"]
        user <- map["user"]
        id = "\(user?.accountId ?? "-1")\(team?.accountId ?? "-2")"
    }

}
