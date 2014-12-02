//
//  TaskModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class TaskModel: NSObject {
    
    // MARK: - Properties
    
    var taskId: Int!
    var body: String!
    var roomId: Int!
    var roomName: String!
    var assignedByAccountId: Int!
    var assignedByAccountName: String!
    var assignedByAccountIconPaht: String!
    var messageId: Int!
    var limitTime: Int!
    var status: String!
    var iconPath: String!
    
    // MARK: - Init
    
    convenience init(json: JSON) {
        self.init()
        
        taskId = json["task_id"].integerValue
        body = json["body"].stringValue
        roomId = json["room"]["room_id"].integerValue
        roomName = json["room"]["name"].stringValue
        assignedByAccountId = json["assigned_by_account"]["account_id"].integerValue
        assignedByAccountName = json["assigned_by_account"]["name"].stringValue
        assignedByAccountIconPaht = json["assigned_by_account"]["avatar_image_url"].stringValue
        messageId = json["message_id"].integerValue
        limitTime = json["limit_time"].integerValue
        status = json["status"].stringValue
        iconPath = json["room"]["icon_path"].stringValue
    }
}
