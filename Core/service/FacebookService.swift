//
//  FacebookService.swift
//  Core
//
//  Created by Carlos Chaguendo on 2/22/19.
//  Copyright © 2019 Chasan. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

public  class FacebookService: Service {
    
    static let url = "https://graph.facebook.com/"
    static let v = "v3.1"
    static let aut = "EAAQmXyaBEO0BABOopJH8aVOGPut6p6oPE5nYAdJiAKO7XZB9LRHOtUmadKsvTfAD7PbtHYfZADtTSZBsNwliu9FiihVjLOggevuf8s3zdv9iE3oyZCfZAaXDRqAgR41FvcAvJ0VqkD8Yq1JHJfCJHGffz1ZC8ObIiqx2BHONdZCpBNSz0bpc6T1"
    static let headers: Dictionary<String, String>  = [
        "Accept":"application/json",
        "Content-Type": "application/json;charset=UTF-8",
        "X-Requested-With": "XMLHttpRequest",
//        "application-type": "JS",
        "Authorization": "Bearer \(FacebookService.aut)"
    ]
    
    public static var sharedInstance: SessionManager = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default;
        
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        FacebookService.headers.forEach({ defaultHeaders[$0] = $1 })
        
        configuration.httpAdditionalHeaders = defaultHeaders
        //timeout 2 minutos
        configuration.timeoutIntervalForRequest = TimeInterval((2 * 60))
        
        //Intercept login when error
        #if DEBUG
        configuration.protocolClasses?.insert(HttpDebugProtocol.self, at: 0)
        #endif
        
        var sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
    
    


    public class func send(message: SendMessage, to recipient: String) -> Promise<SendMessageResponse?> {
        let url = "\(FacebookService.url)\(FacebookService.v)/me/messages"
        let manager = FacebookService.sharedInstance
        

        
        
        
        
        let ms = SendMessageRequest()
        ms.recipient = recipient
        ms.message = message
        
        
        let json = ms.toJSON()
        
        Logger.info(json)
        
        Logger.info("Sinsons")
        
        return Http.request(.post, route: url, parameters: json , manager: manager)
    }
    
    
    
    
}
