//
//  TableSecction.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/20/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit

public class TableSecction<Key: Hashable, Value>: Hashable {
    
    public var items: FiltrableArray<Value>!
    public let key: Key!
    
    public init( key: Key, items: [Value]) {
        self.items = .init(from: items)
        self.key = key
        
    }
    
    public var hashValue: Int { return key.hashValue }
    
    
    public static func == (lhs: TableSecction, rhs: TableSecction) -> Bool {
        return lhs.key == rhs.key
    }
    
    
}

public typealias MapEntry = TableSecction