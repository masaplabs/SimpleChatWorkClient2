//
//  MessageModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/12/01.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class MessageModel: NSObject {
    
    // MARK: - Properties
    
    let meModel: MeModel = MeModel.sharedInstance
    
    var messageId: Int!
    var accountId: Int!
    var name: String!
    var body: String!
    var sendDateTime: Int!
    var updateDateTime: String!
    var iconPath: String!
    var isMyMessage: Bool! = false
    var jsqMessageData: JSQMessageData!
    
    // MARK: - Init
    
    convenience init(json: JSON?) {
        self.init()
        
        messageId = json?["message_id"].integerValue
        accountId = json?["account"]["account_id"].integerValue
        name = json?["account"]["name"].stringValue
        body = json?["body"].stringValue
        sendDateTime = json?["send_time"].integerValue
        updateDateTime = json?["update_time"].stringValue
        iconPath = json?["account"]["avatar_image_url"].stringValue
        
        if (accountId == meModel.accountId) {
            isMyMessage = true
        }
    }
}