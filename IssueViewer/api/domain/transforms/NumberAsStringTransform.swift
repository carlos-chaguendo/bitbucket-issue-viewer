//
//  ISO8601ExtendedDateTransform.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 16/02/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import ObjectMapper

public class NumberAsStringTransform: TransformType {

	public typealias Object = String
	public typealias JSON = NSNumber

	public init() { }

	public func transformFromJSON(_ value: Any?) -> String? {
		guard let value = value else {
			return nil
		}

		return String(describing: value)
	}

	public func transformToJSON(_ value: String?) -> NSNumber? {
		if let value = value {
			return NSNumber(value: Int64(value)!)
		}
		return nil
	}
}
