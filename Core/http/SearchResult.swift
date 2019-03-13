//
//  SearchResult.swift
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

public class SearchResult<T: BasicEntity>: Mappable {

    public var values: [T] = []
    public var size = 0
    public var page = 1
    public var pagelen = 10

    public required convenience init(map: Map) {
        self.init()
    }

    public init(values: [T] = []) {
        self.values = values
        self.size = values.count
    }

    public func mapping(map: Map) {
        values <- (map["values"])
        size <- map["size"]
        page <- map["page"]
        pagelen <- map["pagelen"]

    }

    public init<Other>(other: SearchResult<Other>) {
        other.values
            .compactMap { $0 as? T }
            .forEach { self.values.append($0) }
        size = other.size
        page = other.page
        pagelen = other.pagelen
    }

    public func addAll(values: [T]) {
        self.values.append(contentsOf: values)
    }
}
