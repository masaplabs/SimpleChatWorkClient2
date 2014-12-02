//
//  ChatsViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/10.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ChatsViewModel: NSObject {
    
    // MARK: - Properties
    
    var model: ChatRoomListModel = ChatRoomListModel.sharedInstance
    
    var chats: Array<ChatRoomModel> = []
    
    var isFirstLoad: Bool = true
    
    // MARK: - Singleton
    
    class var sharedInstance: ChatsViewModel {
        struct Static {
            static let instance: ChatsViewModel = ChatsViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // チャットルームリストを取得する
    func getRooms(callback:() -> Void) {
        model.getRooms({chats in
            self.chats = chats as Array
            
            callback()
        })
    }
}
