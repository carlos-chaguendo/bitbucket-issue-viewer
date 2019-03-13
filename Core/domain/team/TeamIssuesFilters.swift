//
//  IssueFilters.swift
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

public class TeamIssuesFilters: BasicEntity {

    @objc public dynamic var team: User?
    @objc public dynamic var repository: Repository!
    @objc public dynamic var assigne: Assignee?
    @objc public dynamic var status: String?
    @objc public dynamic var id: String?

    public override static func primaryKey() -> String? {
        return "id"
    }

    public convenience init(team: User, repository: Repository) {
        self.init()
        id = team.accountId
        self.team = team
        self.repository = repository
    }
}
