//
//  HttpStatusCode.swift
//  AdivantusCore
//
//  Created by carlos chaguendo on 13/05/16.
//  Copyright © 2016 Mayorgafirm. All rights reserved.
//

import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

public class HttpStatusCode: Object, Mappable {

	@objc dynamic var code: String?
	@objc dynamic var message: String?
	@objc dynamic var status: String?

	required convenience public init(map: Map) {
		self.init()
	}

	public func mapping(map: Map) {
		code <- map["code"]
		message <- map["error.message"]
		status <- map["type.type"]
	}

	override public static func primaryKey() -> String? {
		return "code"
	}


}
