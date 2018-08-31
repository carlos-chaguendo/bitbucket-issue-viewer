//
//  RefreshTokenHandler.swift
//  Core
//
//  Created by Carlos Chaguendo on 30/08/18.
//  Copyright © 2018 Chasan. All rights reserved.
//

import UIKit

import Foundation
import Alamofire
import ObjectMapper

class RefreshTokenHandler: RequestAdapter, RequestRetrier {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?, _ error: Error?) -> Void
    
    public typealias RefreshCallback = (_ response: DataResponse<Any>) -> Void
    
    public var oneTimeRefreshCallback: RefreshCallback? = nil
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.protocolClasses?.insert(HttpDebugProtocol.self, at: 0)
        return SessionManager(configuration: configuration)
    }()
    
    
    private var accessToken: String
    private var refreshToken: String
    private var tokenType: String
    private var authorization: String
    
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    private let excludedInternalCodes = [1]
    
    //MARK: - Initialization
    public init(accessToken: String, tokenType: String, refreshToken: String = "") {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        
        authorization = "\(tokenType.capitalized) \(accessToken)"
    }
    
    
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Http.api) {
            var urlRequest = urlRequest
            urlRequest.setValue(authorization, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        
        return urlRequest
    }
    
    public func should(_ manager: Alamofire.SessionManager, retry request: Alamofire.Request, with error: Error, completion: @escaping Alamofire.RequestRetryCompletion) {
        
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                
                if let json = String(data: request.delegate.data!, encoding: String.Encoding.utf8),
                    let params = json.jsonStringToDictionary as? [String: Any],
                    let code = params["internalCode"] as? Int {
                    
                    if self.excludedInternalCodes.contains(code ) {
                        requestsToRetry.forEach { $0(false, 0.0) }
                        return
                    }
                }
                
                refreshTokens { [weak self] succeeded, accessToken, refreshToken, error in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if succeeded {
                        if let accessToken = accessToken, let refreshToken = refreshToken {
                            strongSelf.accessToken = accessToken
                            strongSelf.refreshToken = refreshToken
                            Http.updateAut(token: accessToken, tokenType: refreshToken)
                        }
                        
                        strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    } else {
                        strongSelf.requestsToRetry.forEach { $0(false, 0.0) }
                        
                        
                    }
                    
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        
        let parameters: [String: Any] = [
            "token": refreshToken
        ]
        
        var headers = SessionManager.defaultHTTPHeaders
        headers["X-AUTH-TOKEN"] = accessToken
        
        print(" ♻️ Refrescando \n refreshToken:\(refreshToken)\n accessToken:\(accessToken)")
        sessionManager.request(Http.refresh, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                if let accessToken = response.response?.allHeaderFields["X-AUTH-TOKEN"] as? String,
                    let refreshToken = response.response?.allHeaderFields["X-AUTH-REFRESH-TOKEN"] as? String {
                    
                    strongSelf.oneTimeRefreshCallback?(response)
                    strongSelf.oneTimeRefreshCallback = nil
                    
                    completion(true, accessToken, refreshToken, nil)
                } else {
                    
                    if response.response?.statusCode != 200 {
                        
                        if let responseData = Mapper<HttpStatusCode>().map(JSONObject: response.result.value) {
                            
                            let userInfo: [String: String]? = [NSLocalizedFailureReasonErrorKey: responseData.message!]
                            completion(false, nil, nil, NSError(domain: "com.mayorgafirm.http", code: 403, userInfo: userInfo))
                            
                        } else {
                            completion(false, nil, nil, NSError(domain: "com.mayorgafirm.http", code: 403, userInfo: nil))
                        }
                    }
                }
                
                strongSelf.isRefreshing = false
        }
    }
}

