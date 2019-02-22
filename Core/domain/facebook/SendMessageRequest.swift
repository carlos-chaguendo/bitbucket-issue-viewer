//
//  SendMessage.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

public class SendMessageRequest: BasicEntity {
    
    @objc public dynamic var recipient: String?
    public var message: SendMessage?
    
    required convenience public init(_ map: Map) {
        self.init()
    }
    
    override public func mapping(map:Map){
        super.mapping(map: map)
        recipient <- map["recipient.id"]
        message <- map["message"]
    }
    
}


