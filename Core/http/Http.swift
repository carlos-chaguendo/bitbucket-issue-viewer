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
    internal static var api: String = "https://api.bitbucket.org"
    internal static let refresh = "https://bitbucket.org/site/oauth2/access_token"

    public static let client: (key: String, secret: String) = ("JNK8PLLYakByrYPudb", "fXqLAgn7SHwtgjTXuPw4pjyrnJBRfVyB")

    public static var headers: [String: String] = [
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json",
        "Content-Type": "application/json;charset=UTF-8",
        "x-tok": "Basic Y2FybG9zQ2hhZ3VlbmRvOmNhc2FuMi4w"
    ]

    public static var sharedInstance: SessionManager = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        //setea las cabeceras que no cambian para todas las URLSessionTask, recomendacion https://github.com/Alamofire/Alamofire#response-handling
        Http.headers.forEach({ defaultHeaders[$0] = $1 })
        configuration.httpAdditionalHeaders = defaultHeaders
        //timeout 2 minutos
        configuration.timeoutIntervalForRequest = TimeInterval((2 * 60))

        //Intercept login when error
        #if DEBUG
            configuration.protocolClasses?.insert(HttpDebugProtocol.self, at: 0)
        #endif

        var sessionManager = Alamofire.SessionManager(configuration: configuration)

        if let token: String = UserDefaults.standard.value(forKey: .token),
            let type: String = UserDefaults.standard.value(forKey: .tokenType),
            let refresh: String = UserDefaults.standard.value(forKey: .tokenRefresh) {
            //Http.headers["Authorization"] = "\(type.capitalized) \(token)"

            let tokenHandler = RefreshTokenHandler(accessToken: token, tokenType: type, refreshToken: refresh)
            sessionManager.retrier = tokenHandler //reintenta las peticiones que fallen por refresh token
            sessionManager.adapter = tokenHandler //setea el header de auth
        }
        return sessionManager
    }()

    ///
    /// Update auth token value
    ///
    public static func updateAut(token: String, tokenType: String, refresh: String) {

        UserDefaults.standard.do {
            $0.set(token, forKey: .token)
            $0.set(tokenType, forKey: .tokenType)
            $0.set(refresh, forKey: .tokenRefresh)
            $0.synchronize()
        }

        let tokenHandler = RefreshTokenHandler(accessToken: token, tokenType: tokenType, refreshToken: refresh)
        sharedInstance.retrier = tokenHandler //reintenta las peticiones que fallen por refresh token
        sharedInstance.adapter = tokenHandler //setea el header de auth
    }

    public static func unwrapurl(route: String) -> String {
        var url = route
        if !route.starts(with: "http") {
            url = "\(Http.api)\(route)"

        }
        return url
    }

    public static func validateAcceptableStatusCode(_ response: DataResponse<Data>) -> NSError? {

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

    private static func createRequest(sessionManager: SessionManager = Http.sharedInstance, _ method: HTTPMethod, _ route: String, _ parameters: Parameters? = nil, _ encoding: ParameterEncoding? = JSONEncoding.default) -> Promise<DataRequest> {
        return Promise { seal in

            let url = unwrapurl(route: route)
            let request = sessionManager.request(url, method: method, parameters: parameters, encoding: encoding!)

            request.responseData { data in

                if data.result.isFailure {
                    seal.reject(data.result.error!)
                    return
                }

                if let errorInvalidCode = validateAcceptableStatusCode(data) {
                    seal.reject(errorInvalidCode)
                    return
                }

                seal.resolve(request, nil)
            }
        }
    }

    /// Envia una solicitud de de respuesta multiple
    ///
    /// - Parameters:
    ///   - method: HttpMetod
    ///   - route: url del servicio
    ///   - parameters: Parametros de la solucitud
    ///   - encoding: Tipo de codificacion de los parametros
    /// - Returns: Objetos  Mappable's
    public static func request<Result: Mappable>(_ method: HTTPMethod, route: String, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> Promise<[Result]> {

        return createRequest(method, route, parameters, encoding).then { request in

            return Promise { seal in

                request.responseArray { (result: DataResponse<[Result]>) -> Void in
                    if result.result.isFailure {
                        seal.reject(result.result.error!)
                    } else {
                        seal.resolve(result.result.value, nil)
                    }
                }

            }
        }
    }

    /// Envia una solicitud de de respuesta unica
    ///
    /// - Parameters:
    ///   - method: HttpMetod
    ///   - route: url del servicio
    ///   - parameters: Parametros de la solucitud
    ///   - encoding: Tipo de codificacion de los parametros
    /// - Returns: Objeto unico Mappable
    public static func request<Result: Mappable> (_ method: HTTPMethod, route: String, parameters: Parameters? = nil, encoding: ParameterEncoding? = JSONEncoding.default) -> Promise<Result?> {

        return createRequest(method, route, parameters, encoding).then { request in

            return Promise { seal in

                request.responseObject { (result: DataResponse<Result>) -> Void in
                    if result.result.isFailure {
                        seal.reject(result.result.error!)
                    } else {
                        seal.resolve(result.result.value, nil)
                    }
                }

            }
        }
    }
}
