//
//  Http.swift
//  test-ios
//
//  Created by carlos chaguendo on 20/04/17.
//  Copyright © 2017 Mayorgafirm. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import PromiseKit

public class Http {

	internal static let acceptableStatusCodes: Range<Int> = 200..<300
	internal static var api: String = "https://api.bitbucket.org";

	public static var headers: Dictionary<String, String> = ["X-Requested-With": "XMLHttpRequest", "Accept": "application/json", "Content-Type": "application/json;charset=UTF-8", "Authorization": "Basic Y2FybG9zQ2hhZ3VlbmRvOmNhc2FuMi4w"]

    
    
	public static var sharedInstance: SessionManager = {
		let configuration: URLSessionConfiguration = URLSessionConfiguration.default;

		var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
		//setea las cabeceras que no cambian para todas las URLSessionTask, recomendacion https://github.com/Alamofire/Alamofire#response-handling
		Http.headers.forEach({ defaultHeaders[$0] = $1 })
		configuration.httpAdditionalHeaders = defaultHeaders
		//timeout 2 minutos
		configuration.timeoutIntervalForRequest = TimeInterval((2 * 60))

		//Intercept login when error
        configuration.protocolClasses?.insert(HttpDebugProtocol.self, at: 0)

		var sessionManager = Alamofire.SessionManager(configuration: configuration)
		return sessionManager
	}()


    public static func unwrapurl(route:String) -> String{
        var url = route
        if !route.starts(with: "http") {
            url = "\(Http.api)\(route)"
            
        }
        return url
    }

    public static func request<T: Mappable> (_ rqMethod: HTTPMethod, route: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding? = JSONEncoding.default,headers:HTTPHeaders? = [:],manager:SessionManager? = Http.sharedInstance) -> Promise<T?> {

     

		// verifica rutas externas
		let url = unwrapurl(route: route)


		return Promise<T?> { resolve, reject in

            let localRequest: DataRequest = manager!.request(url, method: rqMethod, parameters: parameters, encoding: encoding!,headers:headers)

			localRequest.responseJSON(completionHandler: { (data: DataResponse<Any>) in

				if data.result.isFailure {
					reject(data.result.error!)
					return
				} else if let errorInvalidCode = validateAcceptableStatusCode(data) {
					reject(errorInvalidCode);
					return
				}

				localRequest.responseObject(completionHandler: { (data: DataResponse<T>) -> Void in
					if data.result.isFailure {
						reject(data.result.error!)
					} else {
						resolve(data.result.value)
					}
				})
			})



		}
	}


	/**
    * Request as Array
    */
	public static func request<T : Mappable>(_ rqMethod: HTTPMethod, route: String, parameters: [String: Any]? = nil, encoding: ParameterEncoding? = JSONEncoding.default,headers:HTTPHeaders? = [:]) -> Promise<[T]?> {

		// verifica rutas externas
		var url = route
		if !route.starts(with: "http") {
			url = "\(Http.api)\(route)"

		}

		return Promise<[T]?> { resolve, reject in

            let localRequest: DataRequest = self.sharedInstance.request(url, method: rqMethod, parameters: parameters, encoding: encoding!,headers: headers)

			localRequest.responseJSON(completionHandler: { (data: DataResponse<Any>) in

				if data.result.isFailure {
					reject(data.result.error!)
					return
				} else if let errorInvalidCode = validateAcceptableStatusCode(data) {
					reject(errorInvalidCode);
					return
				}

				localRequest.responseArray(completionHandler: { (data: DataResponse<[T]>) -> Void in
					if data.result.isFailure { //&& data.response?.statusCode != 401
						reject(data.result.error!)
					} else {
						resolve(data.result.value)
					}
				})
			})

		}

	}


	public static func validateAcceptableStatusCode(_ response: DataResponse<Any>) -> NSError? {

		if Http.acceptableStatusCodes.contains(response.response!.statusCode) {
			return nil
		} else {
			let failureReason = "Response status code was unacceptable: \(response.response!.statusCode)"
			var userInfo = [
				NSLocalizedFailureReasonErrorKey: failureReason
			]

			userInfo["statusCode"] = "\(response.response!.statusCode)"

			if let responseError = Mapper<HttpStatusCode>().map(JSONObject: response.result.value) {
				userInfo[NSLocalizedDescriptionKey] = responseError.message
				userInfo["code"] = responseError.code
			}

			//
			let error = NSError(
				domain: "com.mayorgafirm.http",
				code: -10011,
				userInfo: userInfo
			)

			return (error)
		}

	}


}