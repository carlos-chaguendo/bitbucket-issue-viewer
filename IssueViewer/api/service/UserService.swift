//
//  UserService.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift
import PromiseKit
import ObjectMapper
import AlamofireObjectMapper

public class UserService: Service {

	public class func getUser() -> Promise<User?> {

		return Promise<User?> { (resolve, reject) -> Void in


			let sessionData = realm.objects(SessionData.self)
			if sessionData.count > 0 &&  sessionData[0].user != nil {
				resolve(User(value: sessionData[0].user!))
				return
			}


			Http.request(.get, route: "/2.0/user").then { (user: User?) -> Void in

				guard let user = user else {
					preconditionFailure("No hay session")
				}


				try! realm.write {
					let session = SessionData()
					session.user = user
					realm.add(session, update: true)
				}
				resolve(user)

			}.catch(execute: reject)

		}
	}

}
