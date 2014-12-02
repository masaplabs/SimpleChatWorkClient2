//
//  ProfileViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/10.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    let contactListModel: ContactListModel = ContactListModel.sharedInstance
    
    var accountId: Int!
    var roomId: Int!
    var name: String!
    var chatworkId: String!
    var organizationId: Int!
    var organizationName: String!
    var department: String!
    var iconPath: String!
    var introduction: String?
    
    // MARK: - Singleton
    
    class var sharedInstance: ProfileViewModel {
        struct Static {
            static let instance: ProfileViewModel = ProfileViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // Contact モデルを取得する
    func getModel(accountId: Int) {
        clearModel()
        
        // 自分はコンタクトモデルには入ってない
        if (accountId == MeModel.sharedInstance.accountId) {
            getMyModel()
            return
        }
        
        let model: ContactModel! = contactListModel.getContactModelById(accountId)
        
        self.accountId = model.accountId
        roomId = model.roomId
        name = model.name
        chatworkId = model.chatworkId
        organizationName = model.organizationName
        department = model.department
        iconPath = model.iconPath
    }
    
    // Contact モデルリストを取得しつつ指定したモデルを取得する
    func getModelByIdWithContactList(accountId: Int, callback: () -> Void) {
        contactListModel.getContacts({contacts in
            self.getModel(accountId)
            callback()
        })
    }
    
    // 自分のモデルを取得する
    func getMyModel() {
        clearModel()
        
        let model: MeModel = MeModel.sharedInstance
        
        self.accountId = model.accountId
        roomId = model.roomId
        name = model.name
        chatworkId = model.chatworkId
        organizationName = model.organizationName
        department = model.department
        iconPath = model.iconPath
        introduction = model.introduction
    }
    
    // Contact モデルが存在するか確認する
    func hasModel(accountId: Int) -> Bool {
        // TODO: コンタクト情報が API で個別に取れるようになったらロジックを変更する
        return contactListModel.hasContacts()
    }
    
    func clearModel() {
        accountId = nil
        roomId = nil
        name = nil
        chatworkId = nil
        organizationId = nil
        organizationName = nil
        department = nil
        iconPath = nil
        introduction = nil
    }
    
    // MARK: - Private Method
}