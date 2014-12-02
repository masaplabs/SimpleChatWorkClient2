//
//  FileModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/27.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class FileModel: NSObject {
   
    // MARK: - Properties
    
    var fileId: Int!
    var accountId: Int!
    var uploadAccountName: String!
    var fileName: String!
    var fileSize: Int!
    var messageId: Int!
    var uploadTime: Int!
    
    // MARK: - Init
    
    convenience init(json: JSON) {
        self.init()
        
        fileId = json["file_id"].integerValue
        accountId = json["account"]["account_id"].integerValue
        uploadAccountName = json["account"]["name"].stringValue
        fileName = json["filename"].stringValue
        fileSize = json["filesize"].integerValue
        messageId = json["message_id"].integerValue
        uploadTime = json["upload_time"].integerValue
    }
}
