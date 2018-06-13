//
//  Versions.swift
//  Core
//
//  Created by Carlos Chaguendo on 13/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper

public class Version: BasicEntity {
    
    @objc public dynamic var id: String?
    @objc public dynamic var name: String?
    @objc public dynamic var repository: Repository!

    public override static func primaryKey() -> String? {
        return "id"
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        repository <- map["repository"]
        
        if map.mappingType == .fromJSON {
            id = "\(repository.uuid!)-\(name!)"
        }
    }
}
