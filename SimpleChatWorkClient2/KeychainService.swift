//
//  Keychain.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/27.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit
import Security

let kSecClassValue = NSString(format: kSecClass)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)

class KeychainService {
    
    class func save(key: String, value: NSString!) -> Bool {
        let dataFromString: NSData! = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let query = [
            kSecClassValue : kSecClassGenericPasswordValue,
            kSecAttrAccount : key,
            kSecValueData : dataFromString
        ]
        
        SecItemDelete(query as CFDictionaryRef)
        
        let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
        
        return status == noErr
    }
    
    class func load(key: String) -> NSString? {
        
        let query = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrAccount : key,
            kSecReturnData : kCFBooleanTrue,
            kSecMatchLimit : kSecMatchLimitOne
        ]
        
        var dataTypeRef :Unmanaged<AnyObject>?
        
        let status: OSStatus = SecItemCopyMatching(query, &dataTypeRef)
        
        let opaque = dataTypeRef?.toOpaque()
        
        var contentsOfKeychain: NSString?
        
        if let op = opaque? {
            let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
            
            // Convert the data retrieved from the keychain into a string
            contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding)
        } else {
            println("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        if status == noErr {
            return contentsOfKeychain
        } else {
            return nil
        }
    }
    
    class func delete(key: String) -> Bool {
        let query = [
            kSecClassValue : kSecClassGenericPasswordValue,
            kSecAttrAccount : key
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
    
    class func clear() -> Bool {
        let query = [kSecClassValue: kSecClassGenericPasswordValue]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
}