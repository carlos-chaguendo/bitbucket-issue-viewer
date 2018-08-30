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
