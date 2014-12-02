//
//  RequestSerialization.swift
//  Net
//
//  Created by Le Van Nghia on 7/31/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit

class RequestSerialization {
    var HTTPShouldUsePipelining = false
    var HTTPSouhdHandleCookies = true
    var allowsCellularAccess = true
    
    /**
    *  create new request with method, url, parameters
    *
    *  @param HttpMethod
    *  @param String
    *  @param NSDictionary?
    *  @param NSErrorPointer?
    *
    *  @return
    */
    func requestWithMethod(method: HttpMethod, urlString: String, params: NSDictionary?, error: NSErrorPointer?) -> (NSMutableURLRequest) {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = method.rawValue
        request.HTTPShouldUsePipelining = HTTPShouldUsePipelining
        request.HTTPShouldHandleCookies = HTTPSouhdHandleCookies
        request.allowsCellularAccess = allowsCellularAccess
        
        if params != nil {
            // GET
            if NCWHelper.isQueryParams(method) {
                // send with query params
                let query = NCWHelper.queryStringFromParams(params!)
                let newUrlString = urlString.stringByAppendingString("?\(query)")
                request.URL = NSURL(string: newUrlString)
            }
            else {
                var contentType: String?
                var paramsData: NSData?
                
                if NCWHelper.isMultiPart(params!) {
                    // multi-part for sending large quantities of binary data (as image)
                    let boundary = "NET-POST-boundary-\(arc4random())-\(arc4random())"
                    paramsData = NCWHelper.dataFromParamsWithBoundary(params!, boundary: boundary)
                    contentType = "multipart/form-data; boundary=\(boundary)"
                }
                else {
                    // UTF8 url-encoded body for simple params
                    contentType = "application/x-www-form-urlencoded"
                    let query = NCWHelper.queryStringFromParams(params!)
                    paramsData = query.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                }
                
                if paramsData != nil {
                    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                    request.HTTPBody = paramsData
                }
            }
        }
        
        return request
    }
}
