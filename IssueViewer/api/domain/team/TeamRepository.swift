//
//  TeamRepository.swift
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

public class TeamRepository: BasicEntity {
    
    public dynamic var team: User?
    public dynamic var repository: Repository?
    public dynamic var id: String?
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public convenience init(repository: Repository, team:User) {
        self.init()
        self.repository = repository
        self.team = team
        id = "\(repository.uuid ?? "-1")\(team.accountId ?? "-2")"
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        team <- map["team"]
        repository <- map["repository"]
        id = "\(repository?.uuid  ?? "-1")\(team?.accountId ?? "-2")"
    }
    
}


