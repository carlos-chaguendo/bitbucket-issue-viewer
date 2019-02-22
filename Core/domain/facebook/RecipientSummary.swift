//
//  RecipientSummary.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

public class RecipientSummary: BasicEntity {
    
    @objc public dynamic var subtotal: Int = 0
    @objc public dynamic var shipping: Int = 0
    @objc public dynamic var total: Int = 0
    @objc public dynamic var cost: Int = 0
    
    required convenience public init(_ map: Map) {
        self.init()
    }
    
    override public func mapping(map:Map){
        super.mapping(map: map)
         subtotal <- map["subtotal"]
         shipping <- map["shipping_cost"]
         total <- map["total_tax"]
         cost <- map["total_cost"]
    }
    
}
