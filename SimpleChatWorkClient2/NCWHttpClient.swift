//
//  Net.swift
//  Net
//
//  Created by Le Van Nghia on 7/31/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

class NCWHttpClient: NSObject, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {
    
    let baseURL: NSURL
    var apiToken: NSString!
    
    var HTTPMaximumconnectionsPerHost: Int = 5
    
    private var session: NSURLSession
    private var sessionConfig: NSURLSessionConfiguration
    
    private var requestSerializer: RequestSerialization
    
    typealias SuccessHandler = (ResponseData) -> ()
    typealias FailureHandler = (NSError!) -> ()
    
    override init() {
        baseURL = NSURL(string: "https://api.chatwork.com/v1/")!
        requestSerializer = RequestSerialization()
        
        sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.HTTPMaximumConnectionsPerHost = HTTPMaximumconnectionsPerHost
        
        session = NSURLSession(configuration: sessionConfig)
    }
    
    func setAPIToken(token: NSString) -> Void {
        apiToken = token
        session.configuration.HTTPAdditionalHeaders = ["Accept": "application/json,application/xml,image/png,image/jpeg", "X-ChatWorkToken": apiToken, "User-Agent": "NCW iOS Client/2.0.0"]
    }
    
    func GET(url: String, params: NSDictionary?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> NSURLSessionTask {
        return httpRequest(.GET, url: url, params: params, successHandler: successHandler, failurHandler: failureHandler)
    }
    
    func POST(url: String, params: NSDictionary?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> NSURLSessionTask {
        return httpRequest(.POST, url: url, params: params, successHandler: successHandler, failurHandler: failureHandler)
    }
    
    func PUT(url: String, params: NSDictionary?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> NSURLSessionTask {
        return httpRequest(.PUT, url: url, params: params, successHandler: successHandler, failurHandler: failureHandler)
    }
    
    func DELETE(url: String, params: NSDictionary?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> NSURLSessionTask {
        return httpRequest(.DELETE, url: url, params: params, successHandler: successHandler, failurHandler: failureHandler)
    }
    
    // MARK: - Private Method
    
    private func httpRequest(method: HttpMethod, url: String, params: NSDictionary?, successHandler: SuccessHandler, failurHandler: FailureHandler, isAbsoluteUrl: Bool = false) -> NSURLSessionTask {
        let urlString = isAbsoluteUrl ? url : NSURL(string: url, relativeToURL: baseURL)?.absoluteString
        
        println("HTTP Request: [\(method.rawValue)] " + urlString!)
        
        let request = requestSerializer.requestWithMethod(method, urlString: urlString!, params: params, error: nil)
        let task = createSessionTaskWithRequest(request, successHandler: successHandler, failureHandler: failurHandler)
        task.resume()
        return task
    }
    
    private func createSessionTaskWithRequest(request: NSURLRequest, successHandler: SuccessHandler, failureHandler: FailureHandler) -> NSURLSessionTask {
        let task = session.dataTaskWithRequest(request, completionHandler:{
            (data, response, error) in
            if (error != nil) {
                failureHandler(error)
            } else {
                let responseData = ResponseData(response: response, data: data)
                successHandler(responseData)
            }
        })
        
        return task
    }
}
