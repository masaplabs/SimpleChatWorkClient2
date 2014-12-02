//
//  AddChatRoomViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class AddChatRoomViewModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    let myAccountId: Int! = MeModel.sharedInstance.accountId!
    
    // MARK: - Singleton
    
    class var sharedInstance: AddChatRoomViewModel {
        struct Static {
            static let instance: AddChatRoomViewModel = AddChatRoomViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method

    // チャットルーム作成
    func postRoom(text: String, description: String, adminIds: String, memberIds: String, callback: () -> Void) {
        apiManager.postRoom(text, description: description, adminIds: adminIds, memberIds: "", success: {responseData in
            callback()
        }, error: {error in
            println("新規チャットルーム作成に失敗しました")
        })
    }
}
