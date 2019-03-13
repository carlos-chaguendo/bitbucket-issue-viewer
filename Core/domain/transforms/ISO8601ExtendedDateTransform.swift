//
//  ISO8601ExtendedDateTransform.swift
//  IssueViewer
//
//  Created by Carlos Chaguendo on 16/02/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit
import ObjectMapper

public class ISO8601ExtendedDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String

    public let dateFormatter: DateFormatter

    static let shared = ISO8601ExtendedDateTransform()

    private convenience init() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"
        self.init(formatter)
    }

    public init(_ dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            let dft = dateFormatter.date(from: dateString)
            return dft
        }
        return nil
    }

    public func transformToJSON(_ value: Date?) -> String? {
        if value != nil {
            let interval = value!.timeIntervalSince1970
            let dft = Date(timeIntervalSince1970: interval)
            return dateFormatter.string(from: dft)
        }
        return nil
    }
}
