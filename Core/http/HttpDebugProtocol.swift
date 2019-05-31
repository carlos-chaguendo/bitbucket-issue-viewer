//
//  HttpDebugProtocol.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import UIKit
import Alamofire

public class HttpDebugProtocolSessionDelegate: NSObject, URLSessionDataDelegate {

    private var request: URLRequest!

    public var didReceive: ((URLResponse) -> Void)?
    public var didLoad: ((Data) -> Void)?
    public var didFailWithError: ((Error) -> Void)?
    public var urlProtocolDidFinishLoading: (() -> Void)?

    public init(request: URLRequest!) {
        self.request = request
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let response = response as? HTTPURLResponse {
            let isSecure: Bool = request.allHTTPHeaderFields?["Authorization"] != nil
            Logger.info("Response\(isSecure ? "🔒" : "🔓") <<<<\(self.request.httpMethod!) \(response.url!.absoluteString) \(response.statusCode)")
        }
        completionHandler(.allow)

        didReceive?(response)
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        didLoad?(data)

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        if let error = error {
            self.didFailWithError?(error)
        }

        self.urlProtocolDidFinishLoading?()
        session.finishTasksAndInvalidate()
    }

}

public class HttpDebugProtocol: URLProtocol {

    /// Private under-the-hood session object.
    private var session: URLSession!

    /// Private under-the-hood session task.
    private var sessionTask: URLSessionDataTask!

    /// Private under-the-hood response object
    private var response: HTTPURLResponse?

    /// Private under-the-hood response data object.
    private lazy var responseData: NSMutableData? = NSMutableData()

    private var requestData: URLRequest!

    private let sessionDebug: HttpDebugProtocolSessionDelegate?

    // MARK: NSURLProtocol overrides
    internal override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        self.sessionDebug = HttpDebugProtocolSessionDelegate(request: request)
        super.init(request: request, cachedResponse: cachedResponse, client: client)

        session = URLSession(configuration: URLSessionConfiguration.default, delegate: sessionDebug, delegateQueue: nil)
        requestData = request

        let isSecure: Bool = request.allHTTPHeaderFields?["Authorization"] != nil
        Logger.info("Request \(isSecure ? "🔒" : "🔓") >>>>\(request.httpMethod!) \(request.url!.absoluteString)")

        sessionDebug?.didReceive = { [weak self] response in
            client?.urlProtocol(self!, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.allowed)
        }

        sessionDebug?.didLoad = { [weak self] data in
            client?.urlProtocol(self!, didLoad: data)
        }

        sessionDebug?.urlProtocolDidFinishLoading = { [weak self] in
            client?.urlProtocolDidFinishLoading(self!)
        }

        sessionDebug?.didFailWithError = { [weak self] error in
            client?.urlProtocol(self!, didFailWithError: error)
        }

    }

    open override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    open override func startLoading() {
        sessionTask = session.dataTask(with: request)
        sessionTask.resume()
    }

    open override func stopLoading() {
        sessionTask.cancel()
        self.sessionTask = nil
        self.responseData = nil
        self.response = nil
    }

}
