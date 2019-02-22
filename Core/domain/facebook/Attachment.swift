//
//  Attachment.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

public class Attachment<Content: Payload>: BasicEntity {
    
    @objc public dynamic var type: String = "template"
    public var payload: Content?
    
    required convenience public init(_ map: Map) {
        self.init()
    }
    
    override public func mapping(map:Map){
        super.mapping(map: map)
        type <- map["type"]
        payload <- map["payload"]
    }
    
}
