//
//  ArrayTransform.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class ArrayTransform<T:RealmSwift.Object>: TransformType where T: Mappable {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    let mapper = Mapper<T>()
    
    
    func transformFromJSON(_ value: Any?) -> List<T>? {
        let result = List<T>()
        if let tempArr = value as! Array<AnyObject>? {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model: T = mapper.map(JSONObject: entry)!
                result.append(model)
            }
        }
        return result
    }
    
    // transformToJson was replaced with a solution by @zendobk from https://gist.github.com/zendobk/80b16eb74524a1674871
    // to avoid confusing future visitors of this gist. Thanks to @marksbren for pointing this out (see comments of this gist)
    func transformToJSON(_ value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json as AnyObject)
            }
        }
        return results
    }
}
