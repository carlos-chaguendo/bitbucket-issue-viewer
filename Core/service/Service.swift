//
//  Service.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//
import UIKit
import RealmSwift
import PromiseKit
import Alamofire

extension String {
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}

public class Service {
    
    
    static let null = NSNull()

    private static var configuration: Realm.Configuration?

    private static func getKey() -> Data? {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "com.mayorgafirm.test.EncryptionKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        // First check in the keychain for an existing key
        var query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keychainIdentifierData,
            kSecAttrKeySizeInBits as String: 512,
            kSecReturnData as String: true
        ]

        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }

        // No pre-existing key from this application, so generate a new one
        var keyData = Data(count: 64)

        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, keyData.count, $0)
        }
        //        print(keyData.base64EncodedString())
        assert(result == errSecSuccess, "Failed to get random bytes")

        // Store the key in the keychain
        query = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keychainIdentifierData,
            kSecAttrKeySizeInBits as String: 512,
            kSecValueData as String: keyData
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")

        return keyData
    }


    public static var realm: Realm = {

        if configuration == nil {
            configuration = Realm.Configuration(encryptionKey: Service.getKey(), schemaVersion: 2,
                                                migrationBlock: { migration, oldSchemaVersion in
                                                    if (oldSchemaVersion < 2) {
                                                        print("old Schema = \(oldSchemaVersion)")
                                                        // Nothing to do!
                                                        // Realm will automatically detect new properties and removed properties
                                                        // And will update the schema on disk automatically
                                                    }
                                                })
        }

//        let realm = try! Realm(configuration: configuration!)
        let realm = try! Realm()
        return realm
    }()


    public static func printLog(_ log: String) {
        print("[\(type(of: self))]  \(log)")
    }

    public static func postNotificationName(aName: String, object anObject: AnyObject?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: aName), object: anObject)
    }

    public static func postNotificationName(aName: String, object anObject: AnyObject?, userInfo aUserInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: aName), object: anObject, userInfo: aUserInfo)
        
      
    }
    
    public static func select<T>(from entityType: T.Type, where filter:NSPredicate, decoreBeforeSaving:((T) -> Void)? = nil , orConnectTo route: String) -> Promise<SearchResult<T>?> {
        return Promise<SearchResult<T>?> { (resolve, reject) in

            let localData = realm.objects(entityType).filter(filter).detached

            // Datos locales desligados
            // si no existen localmente se va al servidor
            if localData.isEmpty {
                save(resultOf: Http.request(.get, route: route), beforeSaving: decoreBeforeSaving)
                    .then(execute: resolve)
                    .catch(execute: reject)

                return
            }

            resolve(SearchResult<T>(values: localData))

        }
    }

    public static func save<T>(resultOf promise: Promise<SearchResult<T>?>, beforeSaving:((T) -> Void)? = nil  ) -> Promise<SearchResult<T>?> {
        return Promise<SearchResult<T>?> { (resolve, reject) in
            promise.then { (result) -> Void in
                try! realm.write {
                    for item in (result?.values).orEmpty {
                        beforeSaving?(item)
                        realm.add(item, update: true)
                    }
                }
                resolve(result)
            }.catch(execute: reject)
        }
    }

    
    public class func `_q`(_ format:String, _ arguments: [Any]?) -> NSPredicate {
        return NSPredicate(format: format, argumentArray: arguments )
    }

}