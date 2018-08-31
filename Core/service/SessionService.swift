//
//  SessionService.swift
//  Core
//
//  Created by Carlos Chaguendo on 31/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

public class SessionService: Service {
    
    public class var islogged: Bool {
        let token: String? = UserDefaults.standard.value(forKey: UserDefaults.Key.token)
        return token != nil
    }

}
