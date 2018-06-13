//
//  UserDefaults.swift
//  Core
//
//  Created by Carlos Chaguendo on 13/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

public extension UserDefaults {
    
    public subscript<T>(key: String) -> T? {
        get {
            return value(forKey: key) as? T
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    public subscript<T: RawRepresentable>(key: String) -> T? {
        get {
            if let rawValue = value(forKey: key) as? T.RawValue {
                return T(rawValue: rawValue)
            }
            return nil
        }
        set {
            set(newValue?.rawValue, forKey: key)
        }
    }
}
