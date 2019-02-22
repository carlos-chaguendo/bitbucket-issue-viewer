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

public class SendMessage: BasicEntity {
     @objc public dynamic var text: String?
}

public class SendMessageAttachment<Content: Payload>: SendMessage {
    
    public var attachment: Attachment<Content>?
    
    required convenience public init(_ map: Map) {
        self.init()
    }
    
    override public func mapping(map:Map){
        super.mapping(map: map)
        text <- map["text"]
        attachment <- map["attachment"]
    }
    
}
