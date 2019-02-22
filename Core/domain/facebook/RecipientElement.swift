//
//  RecipientElement.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

public class RecipientElement: BasicEntity {
    
    @objc public dynamic var title: String?
    @objc public dynamic var subtitle: String?
    @objc public dynamic var quantity: Int = 0
    @objc public dynamic var price: Int = 0
    @objc public dynamic var currency: String = "COP"
    @objc public dynamic var image: String?
    
    required convenience public init(_ map: Map) {
        self.init()
    }
    
    override public func mapping(map:Map){
        super.mapping(map: map)
         title <- map["title"]
         subtitle <- map["subtitle"]
         quantity <- map["quantity"]
         price <- map["price"]
         currency <- map["currency"]
         image <- map["image_url"]
    }
    
}
