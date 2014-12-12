//
//  MeModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/17.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class MeModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    var accountId: Int?
    var roomId: Int?
    var name: String?
    var chatworkId: String?
    var organizationId: Int?
    var organizationName: String?
    var department: String?
    var title: String?
    var url: String?
    var introduction: String?
    var mail: String?
    var telOrganization: String?
    var telExtension: String?
    var telMobile: String?
    var skypeId: String?
    var twitterId: String?
    var facebookId: String?
    var iconPath: String?
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Singleton
    
    class var sharedInstance: MeModel {
        struct Static {
            static let instance: MeModel = MeModel()
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
    
    func signIn(token: String, callback: () -> Void) {
        apiManager.signIn(token, success: {model in
            // ログイントークンをキーチェーンに保存
            KeychainService.save("LoginToken", value: token)
            
            self.setModel(model)
            
            callback()
        }, error: {error in
            // ログイン情報を削除
            KeychainService.delete("LoginToken")
            println("ログインに失敗しました")
        })
    }
    
    // MARK: - Private Method
    
    private func setModel(model: JSON) {
        accountId = model["account_id"].integerValue
        roomId = model["room_id"].integerValue
        name = model["name"].stringValue
        chatworkId = model["chatwork_id"].stringValue
        organizationId = model["organization_id"].integerValue
        organizationName = model["organization_name"].stringValue
        department = model["department"].stringValue
        title = model["title"].stringValue
        url = model["url"].stringValue
        introduction = model["introduction"].stringValue
        mail = model["mail"].stringValue
        telOrganization = model["tel_organization"].stringValue
        telExtension = model["tel_extension"].stringValue
        telMobile = model["tel_mobile"].stringValue
        skypeId = model["skype"].stringValue
        twitterId = model["twitter"].stringValue
        facebookId = model["facebook"].stringValue
        iconPath = model["avatar_image_url"].stringValue
    }
}
