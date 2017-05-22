//
//  HttpDebugProtocol.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Alamofire

public class HttpDebugProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate {

	/// Private under-the-hood session object.
	private var session: URLSession!

	/// Private under-the-hood session task.
	private var sessionTask: URLSessionDataTask!

	/// Private under-the-hood response object
	private var response: HTTPURLResponse?

	/// Private under-the-hood response data object.
	private lazy var responseData = NSMutableData()

	private var requestData: URLRequest!


	// MARK: NSURLProtocol overrides
	internal override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
		super.init(request: request, cachedResponse: cachedResponse, client: client)
		session = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: nil)
		sessionTask = session.dataTask(with: request)
		requestData = request;

		let isSecure: Bool = request.allHTTPHeaderFields?["Authorization"] != nil
		print("Request \(isSecure ? "🔒" : "🔓") >>>>\(request.httpMethod!) \(request.url!.absoluteString)")
	}


	open override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

	open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	open override func startLoading() {
		sessionTask.resume();
	}


	open override func stopLoading() {
		sessionTask.cancel()
	}

	public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

		if let response = response as? HTTPURLResponse {
			self.response = response

			let isSecure: Bool = requestData.allHTTPHeaderFields?["Authorization"] != nil
			print("Response\(isSecure ? "🔒" : "🔓") <<<<\(self.requestData.httpMethod!) \(response.url!.absoluteString) \(response.statusCode)")
		}
		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.allowed)
		completionHandler(.allow)

	}

	public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		client?.urlProtocol(self, didLoad: data)
		responseData.append(data)
	}

	public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		if let error = error {
			client?.urlProtocol(self, didFailWithError: error)
		}
		client?.urlProtocolDidFinishLoading(self)
	}


}


