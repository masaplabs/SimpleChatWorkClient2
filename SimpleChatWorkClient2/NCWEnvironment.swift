//
//  NCWEnvironment.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/28.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import Foundation

class NCWEnvironment: NSObject {

    let meModel: MeModel = MeModel.sharedInstance
    
    func isLogin() -> Bool {
        let token: String? = KeychainService.load("LoginToken")
        
        if ((token) != nil) {
            meModel.signIn(token!, callback: {
                
            })
            
            return true
        }
        
        return false
    }
    
    func byteString(byte: Int) -> String {
        let floatByte = Float(byte)
        var changedString = ""
        
        if (byte < 1024) {
            changedString = String(byte) + " B"
        } else if (byte < 1024 * 1240) {
            changedString = String(format: "%.2f", Float(floatByte / 1024)) + " KB"
        } else if (byte < 1024 * 1024 * 1024) {
            changedString = String(format: "%.2f", Float(floatByte / (1024 * 1024))) + " MB"
        } else {
            changedString = String(format: "%.2f", Float(floatByte / (1024 * 1024 * 1024))) + " GB"
        }
        
        return changedString
    }
}
