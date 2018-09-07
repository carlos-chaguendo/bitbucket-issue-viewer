//
//  SessionService.swift
//  Core
//
//  Created by Carlos Chaguendo on 31/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import PromiseKit

public class SessionService: Service {

	public class var islogged: Bool {
		let token: String? = UserDefaults.standard.value(forKey: UserDefaults.Key.token)
		return token != nil
	}


	public class func logout() -> Promise<Void> {
		return Promise<Void> { (resolve, _) -> Void in
			UserDefaults.standard.do {
				$0.remove(forKey: .token)
				$0.remove(forKey: .tokenType)
				$0.synchronize()
			}

			try! realm.write {
				realm.deleteAll()
			}

			resolve(())
		}
	}


}
