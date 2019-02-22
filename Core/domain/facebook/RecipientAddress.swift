//
//  RecipientAddress.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

public class RecipientAddress: BasicEntity {

    @objc public dynamic var street: String?
    @objc public dynamic var street2: String = String.empty
    @objc public dynamic var city: String?
    @objc public dynamic var postalCode: String?
    @objc public dynamic var state: String?
    @objc public dynamic var country: String?


    required convenience public init(_ map: Map) {
        self.init()
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        street <- map["street_1"]
        street2 <- map["street_2"]
        city <- map["city"]
        postalCode <- map["postal_code"]
        state <- map["state"]
        country <- map["country"]

    }

}
