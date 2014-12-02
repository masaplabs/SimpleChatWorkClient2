//
//  ResponseSerialization.swift
//  Net
//
//  Created by Le Van Nghia on 7/31/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
import Foundation

class ResponseData {
    var urlResponse: NSURLResponse
    var data: NSData
    
    init(response: NSURLResponse, data: NSData) {
        self.urlResponse = response
        self.data = data
    }
    
    func json(error: NSErrorPointer = nil) -> JSON? {
        let httpResponse = urlResponse as NSHTTPURLResponse
        if httpResponse.statusCode == 200 {
            let jsonData = JSON(data: data)
            
            let name = jsonData[0]["name"].stringValue
            return jsonData
        } else if error != nil {
            error.memory = NSError(domain: "HTTP_ERROR_CODE", code: httpResponse.statusCode, userInfo: nil)
        }
        
        return nil
    }
    
    func image(error: NSErrorPointer = nil) -> UIImage? {
        let httpResponse = urlResponse as NSHTTPURLResponse
        if httpResponse.statusCode == 200 && data.length > 0 {
            return UIImage(data: data)
        }
        else if error != nil {
            error.memory = NSError(domain: "HTTP_ERROR_CODE", code: httpResponse.statusCode, userInfo: nil)
        }
        
        return nil
    }
    
    func parseXml(delegate: NSXMLParserDelegate, error: NSErrorPointer = nil) -> Bool {
        let httpResponse = urlResponse as NSHTTPURLResponse
        if httpResponse.statusCode == 200 {
            let xmlParser = NSXMLParser(data: data)
            xmlParser.delegate = delegate
            xmlParser.parse()
            return true
        }
        else if error != nil {
            error.memory = NSError(domain: "HTTP_ERROR_CODE", code: httpResponse.statusCode, userInfo: nil)
        }
        
        return false
    }
}
