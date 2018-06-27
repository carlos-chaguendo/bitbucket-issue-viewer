//
//  PromiseKit+Support4.swift
//  Core
//
//  Created by Carlos Chaguendo on 27/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import PromiseKit

public extension Promise {
    
    /// support PromiseKit 4 initializer
    internal convenience  init(previusResolvers: (_ fulfill: @escaping (T) -> Void, _ reject: @escaping (Error) -> Void) throws -> Void) {
        self.init(resolver: { seal in
            do {
                try previusResolvers(seal.fulfill, seal.reject)
            } catch {
                seal.reject(NSError(domain: "Promise", code: -1001, userInfo: [NSLocalizedFailureReasonErrorKey : "No se pudo ejecutar soporte de promiseKit 4 a 6, use Promise { seal in .... seal.resolve(_:_) } "]))
            }
        })
    }
    
//    public func always(execute body: @escaping () -> Void) -> Promise {
//        return self.ensure(body)
//    }
    
    
}


extension Thenable {

    /// support promiseKit 4
//    public func then( execute executer : @escaping(T) throws -> Void) -> Promise<Void> {
//        return self.done(executer)
//    }
}


extension CatchMixin {
    
    /// support promiseKit 4
    @discardableResult
    public func `catch`(execute: @escaping (Error) -> Void) -> PMKFinalizer {
        return self.catch(execute)
    }

    
}
