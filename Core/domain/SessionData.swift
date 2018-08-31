//
//  SessionData.swift
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

public class SessionData: BasicEntity {


	@objc private dynamic var id: String?
	@objc public internal(set) dynamic var user: User? {
		didSet {
			id = user?.username
		}
	}
    
    @objc public dynamic var token: String?


	public override static func primaryKey() -> String? {
		return "id"
	}


	public required convenience init(_ map: Map) {
		self.init()
	}
}
