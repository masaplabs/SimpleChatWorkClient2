//
//  ContactListModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ContactListModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    var contacts: Array<ContactModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: ContactListModel {
        struct Static {
            static let instance: ContactListModel = ContactListModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // コンタクトリストを取得する
    func getContacts(callback: (AnyObject?) -> ()) {
        // append するため最初に空にする
        contacts = []
        
        apiManager.getContacts({responseData in
            // コンタクトリストからコンタクトモデルを作成し、 contacts リストに入れていく
            let contactModels: JSON! = responseData.json(error:nil)
            for var i = 0, num = contactModels.arrayValue?.count; i < num; i++ {
                var contactModel: JSON = contactModels[i]
                self.contacts.append(ContactModel(json: contactModel))
            }
            
            callback(self.contacts)
            }, error: {error in
                println("コンタクトリスト読み込み失敗")
        })
    }
    
    // ID から ChatRoomModel を取得する
    func getContactModelById(accountId: Int) -> ContactModel?{
        var modelList = contacts.filter({$0.accountId == accountId})
        
        // 取得できなかった場合
        if (modelList.count == 0) {
            println("指定した accountId: \(accountId) のモデルを取得できませんでした")
            return nil
        }
        
        return modelList[0]
    }
    
    // コンタクトリストを取得しているか
    func hasContacts() -> Bool {
        return contacts.count > 0
    }
}
