//
//  String.swift
//  Core
//
//  Created by Carlos Chaguendo on 30/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

public extension String {

    
    public func substring(between start: String, and end: String, includeBrackets:Bool = true) -> String? {
        
        guard let range = self.range(of: start) else {
            return nil
        }
        
        let a: String.Index = includeBrackets ? range.lowerBound : range.upperBound
        let html = String(self[a...])
        guard let endRange = html.range(of: end) else {
            return nil
        }
        
        let b: String.Index = includeBrackets ? endRange.upperBound : endRange.lowerBound
        return String(html[..<b])
    }
    
    
    
}

extension String {
    
    public var jsonStringToDictionary: AnyObject? {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                let message = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                if let jsonResult = message as? NSMutableArray {
                    return jsonResult //Will return the json array output
                } else if let jsonResult = message as? NSMutableDictionary {
                    return jsonResult //Will return the json dictionary output
                } else {
                    return nil
                }
            }
            catch let error as NSError {
                print("An error occurred: \(error)")
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
