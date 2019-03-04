//
//  Logger.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/20/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import Foundation

public struct Logger {
    
    public enum Level: String {
        case info = "INFO"
        case error = "ERROR"
    }

    public static func info(_ items: Any, _ other: Any = String.empty, file: String = #file, line: Int = #line) {
        Logger.log(.info, items, other, file: file, line: line)
    }

    public static func error(_ items: Any, _ other: Any = String.empty, file: String = #file, line: Int = #line) {
        Logger.log(.error, items, other, file: file, line: line)
    }

    public static func log(_ level: Level, _ items: Any, _ other: Any = String.empty, file: String = #file, line: Int = #line) {
        let name = file.components(separatedBy: "/").last.or(else: file)
        let mas = "[\(level.rawValue)] [\(name) - line \(line)] "
        Swift.print(mas, items, other, separator: "\t\t\t", terminator: "\n")
    }

}
