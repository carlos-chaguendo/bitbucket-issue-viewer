//
//  UserDefaults.swift
//  Core
//
//  Created by Carlos Chaguendo on 13/06/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

extension UserDefaults {

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

extension UserDefaults {

    public struct Key: Hashable, RawRepresentable, ExpressibleByStringLiteral {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            self.rawValue = value
        }
    }

    public func set<T>(_ value: T?, forKey key: Key) {

        if key == .tokenType {

            if let str = value as? String {
                if str != "bearer" {
                    preconditionFailure()
                }
            }
        }

        set(value, forKey: key.rawValue)
    }

    public func value<T>(forKey key: Key) -> T? {
        return value(forKey: key.rawValue) as? T
    }

    public func remove(forKey key: Key) {
        removeObject(forKey: key.rawValue)
    }

    public subscript<T>(key: Key) -> T? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key.rawValue) }
    }

}

extension UserDefaults.Key {

    /// La url que el usario puede configurar manualmente la del usuario tiene prioridad
    public static let token: UserDefaults.Key = "access_token"

    public static let tokenType: UserDefaults.Key = "token_type"

    public static let tokenRefresh: UserDefaults.Key = "refresh_token"

}
