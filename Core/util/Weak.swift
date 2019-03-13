//
//  Weak.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/21/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit

public struct Strong {

    /// Permite la ejecucion de un bloque cuando, con la referencia liviana a una variable
    ///
    /// - Parameters:
    ///   - context1: Variable que necesita que exista para que el bloque se ejecute
    ///   - message: Mensaje cuando context1 no existe
    ///   - closure: Funcion a ejecutar
    public static func weak<Context1: AnyObject>(_ context1: Context1?, message: String? = nil, file: String = #file, line: Int = #line, closure: @escaping(Context1) -> Void) -> () -> Void {
        return { [weak context1] in
            guard let strongContext1 = context1 else {
                if let message = message {
                    Logger.info(message, file: file, line: line)
                }
                return
            }
            closure(strongContext1)
        }
    }

    /// Permite la ejecucion de un bloque cuando, con la referencia liviana a una variable
    ///
    /// - Parameters:
    ///   - context1: Variable que necesita que exista para que el bloque se ejecute
    ///   - message: Mensaje cuando context1 no existe
    ///   - closure: Funcion a ejecutar
    public static func weak<Context1: AnyObject, Argument1>(_ context1: Context1?, message: String? = nil, file: String = #file, line: Int = #line, closure: @escaping(Context1, Argument1) -> Void) -> (Argument1) -> Void {
        return { [weak context1] argument1 in
            guard let strongContext1 = context1 else {
                if let message = message {
                    Logger.info(message, file: file, line: line)
                }
                return
            }
            closure(strongContext1, argument1)
        }
    }
}
