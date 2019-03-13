//
//  NSURLRequest+Curl.swift
//  AdivantusCore
//
//  Created by carlos chaguendo on 24/11/16.
//  Copyright © 2016 Mayorgafirm. All rights reserved.
//

import Foundation

extension NSURLRequest {

	/**
     *  Returns a cURL command for a request.
     *
     *  @return A String object that contains cURL command or nil if an URL is
     *  not properly initalized.
     */
	func cURL() -> String? {
		if let url = self.url {
			let length = url.absoluteString.utf16.count
			if length == 0 {
				return nil
			}

			let curlCommand = NSMutableString()
			curlCommand.append("curl")

			// append URL
			curlCommand.appendFormat(" '%@'", url as CVarArg)

			// append method if different from GET
			if "GET" != self.httpMethod {
				curlCommand.appendFormat(" -X %@", self.httpMethod!)
			}

			// append headers
			if let allHTTPHeaderFields = self.allHTTPHeaderFields {
				let allHeadersKeys = Array(allHTTPHeaderFields.keys)
				let sortedHeadersKeys = allHeadersKeys.sorted()
				for key in sortedHeadersKeys {
					curlCommand.appendFormat(" -H '%@: %@'",
					                                   key, self.value(forHTTPHeaderField: key)!)
				}
			}

			// append HTTP body
			if let httpBody = self.httpBody, httpBody.count > 0 {

				if let body = NSString(data: httpBody, encoding: String.Encoding.utf8.rawValue) {
					let escapedHttpBody =
						NSURLRequest.escapeAllSingleQuotes(value: String(body))
					curlCommand.appendFormat(" --data '%@'", escapedHttpBody)
				}

			}

			return String(curlCommand)
		}

		return nil
	}

	/**
     *  Escapes all single quotes for shell from a given string.
     *
     *  @param value The value to escape.
     *
     *  @return An escaped value.
     */
	class func escapeAllSingleQuotes(value: String) -> String {

		return value.replacingOccurrences(of: "'", with: "'\\''")
	}
}
