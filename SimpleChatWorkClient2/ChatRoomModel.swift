//
//  ChatRoomModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/18.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ChatRoomModel: NSObject {
    
    // MARK: - Properties
    
    var roomId: Int!
    var name: String!
    var chatType: String!
    var role: String!
    var sticky: Bool!
    var unreadNumber: Int!
    var mentionNumber: Int!
    var myTaskNumber: Int!
    var messageNumber: Int!
    var fileNumber: Int!
    var taskNumber: Int!
    var iconPath: String!
    var lastUpdateTime: Int!
    var roomDescription: String?
    
    // MARK: - Init
    
    convenience init(json: JSON) {
        self.init()
        
        roomId = json["room_id"].integerValue
        name = json["name"].stringValue
        chatType = json["type"].stringValue
        role = json["role"].stringValue
        sticky = json["sticky"].boolValue
        unreadNumber = json["unread_num"].integerValue
        mentionNumber = json["mention_num"].integerValue
        myTaskNumber = json["mytask_num"].integerValue
        messageNumber = json["message_num"].integerValue
        fileNumber = json["file_num"].integerValue
        taskNumber = json["task_num"].integerValue
        iconPath = json["icon_path"].stringValue
        lastUpdateTime = json["last_update_time"].integerValue
    }
}
