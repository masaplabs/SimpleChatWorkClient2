//
//  ProfileModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/10.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    var accountId: Int?
    var roomId: Int?
    var name: String?
    var chatworkId: String?
    var organizationId: Int?
    var organizationName: String?
    var department: String?
    var iconPath: String?
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Singleton
    
    class var sharedInstance: ProfileModel {
        struct Static {
            static let instance: ProfileModel = ProfileModel()
        }
        return Static.instance
    }
    
    // MARK: - Public Method
    
    func getMy() {
        apiManager.getMy({model in
            self.setModel(model)
        }, error: {error in
            println("自分の情報読み込み失敗")
        })
    }
    
    // MARK: - Private Method
    
    private func setModel(model: JSON) {
        accountId = model["account_id"].integerValue
        roomId = model["room_id"].integerValue
        name = model["name"].stringValue
        chatworkId = model["chatwork_id"].stringValue
        organizationId = model["organization_id"].integerValue
        organizationName = model["organizaation_name"].stringValue
        department = model["department"].stringValue
        iconPath = model["avatar_image_url"].stringValue
    }
}
