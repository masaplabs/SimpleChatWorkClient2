//
//  ContactModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ContactModel: NSObject {
    
    // MARK: - Properties
    
    var accountId: Int!
    var roomId: Int!
    var name: String!
    var chatworkId: String!
    var organizationId: Int!
    var organizationName: String!
    var department: String!
    var iconPath: String!
    
    // MARK: - Init
    
    convenience init(json: JSON) {
        self.init()
        
        accountId = json["account_id"].integerValue
        roomId = json["room_id"].integerValue
        name = json["name"].stringValue
        chatworkId = json["chatwork_id"].stringValue
        organizationId = json["organization_id"].integerValue
        organizationName = json["organization_name"].stringValue
        department = json["department"].stringValue
        iconPath = json["avatar_image_url"].stringValue
    }
}
