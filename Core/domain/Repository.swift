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

    @objc public dynamic var fullName: String?
    @objc public dynamic var name: String?
    @objc public dynamic var type: String?
    @objc public dynamic var uuid: String?
    @objc public dynamic var ownerUsername: String?

    @objc public var hasIssues: Bool = false
    @objc fileprivate dynamic var _slug: String?

    public var slug: String? {
        return _slug.or(else: name)
    }

    public override static func primaryKey() -> String? {
        return "uuid"
    }

    override public func mapping(map: Map) {

        fullName <- map["full_name"]
        name <- map["name"]
        type <- map["type"]
        uuid <- map["uuid"]
        _slug <- map["slug"]
        hasIssues <- map["has_issues"]
        ownerUsername <- map["owner.username"]

    }

}

public class RepositoryInCache: Repository {

    @objc public dynamic var page: Int = 1

}
