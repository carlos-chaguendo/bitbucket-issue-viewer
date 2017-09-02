//
//  IssueEdited.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 1/09/17.
//  Copyright © 2017 Chasan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class IssueEdited: BasicEntity {

    public var state: IssueStatus?
    public dynamic var title: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        state <- (map["status"], EnumTransform())
        title <- map["title"]
    }

}
