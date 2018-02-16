//
//  Optional+Chaining.swift
//  AdivantusCore
//
//  Created by Carlos Chaguendo on 19/12/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

extension Optional {
    
    public func `or`(else value : Wrapped?) -> Optional {
        return self ?? value
    }
    
    public func `or`(else value: Wrapped) -> Wrapped {
        return self ?? value
    }
    
}

/// Referencia  unica a una cadena vacia
fileprivate let StringEmpty: String = ""

extension Optional where Wrapped == String {
    
    public var orEmpty: String {
        return self.or(else: StringEmpty)
    }
    
}

/// Referencia  unica a un array vacio
fileprivate let ArrayEmpty: Array<Any> = []

extension Optional where Wrapped: Sequence {
    
    public var orEmpty:Wrapped {
        if self == nil {
            // Evita estar creando arrays vacios en memoria
            return ArrayEmpty as! Wrapped
        }
        return self!
    }
    
    
}

