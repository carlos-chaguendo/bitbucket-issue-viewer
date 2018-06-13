//
//  Realm+detached.swift
//  Core
//
//  Created by Carlos Chaguendo on 13/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

public extension Object {
    
    public func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let detachable = value as? Object {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

public extension Sequence where Iterator.Element: Object {
    
    public var detached: [Element] {
        return self.map({ $0.detached() })
    }
}
