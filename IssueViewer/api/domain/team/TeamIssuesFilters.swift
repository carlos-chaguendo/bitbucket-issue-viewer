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
    
    public dynamic var team: User?
    public dynamic var repository: Repository!
    public dynamic var assigne: Assignee?
    public dynamic var status: String?
    
    public dynamic var id: String?
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public convenience init(team:User, repository:Repository) {
        self.init()
        id = team.accountId
        self.team = team
        self.repository = repository
    }
    
    
    
    
    

}
