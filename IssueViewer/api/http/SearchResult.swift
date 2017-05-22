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

public class SearchResult<T:BasicEntity>: Mappable {

	public var values: Array<T> = []
	public var size = 0
	public var page = 1
	public var pagelen = 10

	public required convenience init(map: Map) {
		self.init()
	}

	public func mapping(map: Map) {
		values <- (map["values"])
		size <- map["size"]
		page <- map["page"]
		pagelen <- map["pagelen"]
	}

}
