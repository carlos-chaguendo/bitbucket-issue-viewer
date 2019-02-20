//
//  Math.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/20/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit

/**
 (Restringir, Bloquear) limita un valor dentro de los límites inferior y superior inclusivos.
 
 Verificar si se acepta la siguiente implemnetacion
 https://github.com/apple/swift-evolution/blob/master/proposals/0177-add-clamped-to-method.md
 
 - Parameters:
 - value: El valor a limitar
 - lower: El limite inferior
 - upper: El limite supperior
 - Returns: Devuelve el valor bloqueado.
 */
public func clamp<T>(_ value: T, between lower: T, and upper: T) -> T where T : Comparable {
    return max(min(value, upper), lower)
}




public extension Comparable  {
    
    /**
     (Restringir, Bloquear) limita un valor dentro de 2 valores.
     ```
     heightConstraint.constant = heightConstraint.constant == 0 ? 200 : 0
     
     /// llamado simple
     heightConstraint.constant.toggle(between: 0, or: 200)
     ```
     
     */
    public mutating func toggle( between a: Self, or b: Self) -> Void  {
        self = self == a ? b : a
    }
    
}

