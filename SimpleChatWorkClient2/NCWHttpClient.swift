//
//  Net.swift
//  Net
//
//  Created by Le Van Nghia on 7/31/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import Foundation
import Alamofire

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
    
    private var sessionConfig: NSURLSessionConfiguration
    private var manager: Manager
    private var request: Alamofire.Request?
    
    typealias SuccessHandler = (JSON!) -> ()
    typealias FailureHandler = (NSError!) -> ()
    
    override init() {
        baseURL = NSURL(string: "https://api.chatwork.com/v1/")!
        
        sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.HTTPMaximumConnectionsPerHost = HTTPMaximumconnectionsPerHost
        
        manager = Alamofire.Manager(configuration: sessionConfig)
    }
    
    func setAPIToken(token: NSString) -> Void {
        apiToken = token
        manager.session.configuration.HTTPAdditionalHeaders = ["Accept": "application/json,application/xml,image/png,image/jpeg", "X-ChatWorkToken": apiToken, "User-Agent": "NCW iOS Client/2.0.0"]
    }
    
    func GET(url: String, params: [String: AnyObject]?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> Request {
        return httpRequest(Alamofire.Method.GET, url: url, params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    func POST(url: String, params: [String: AnyObject]?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> Request {
        return httpRequest(Alamofire.Method.POST, url: url, params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    func PUT(url: String, params: [String: AnyObject]?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> Request {
        return httpRequest(Alamofire.Method.PUT, url: url, params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    func DELETE(url: String, params: [String: AnyObject]?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> Request {
        return httpRequest(Alamofire.Method.DELETE, url: url, params: params, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    // MARK: - Private Method
    
    private func httpRequest(method: Alamofire.Method, url: String, params: [String: AnyObject]?, successHandler: SuccessHandler, failureHandler: FailureHandler) -> Request {
        let urlString = NSURL(string: url, relativeToURL: baseURL)!.absoluteString!
        
        println("HTTP Request: [\(method.rawValue)] " + urlString)
        
        request = manager.request(method, urlString, parameters: params)
        request?.responseJSON({ (request, response, data, error) -> Void in
            if (error != nil) {
                failureHandler(error)
            } else {
                successHandler(JSON(object: data!))
            }
        })
        
        return request!
    }
}