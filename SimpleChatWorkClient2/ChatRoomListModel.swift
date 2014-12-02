//
//  ChatRoomListModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/18.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ChatRoomListModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    var chats: Array<ChatRoomModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: ChatRoomListModel {
        struct Static {
            static let instance: ChatRoomListModel = ChatRoomListModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // チャットルームリストを取得する
    func getRooms(callback: (AnyObject?) -> ()) {
        // append するため最初に空にする
        chats = []
        
        apiManager.getRooms({responseData in
            // チャットルームリストからチャットルームモデルを作成し、 chats リストに入れていく
            let roomModels: JSON! = responseData.json(error:nil)
            for var i = 0, num = roomModels.arrayValue?.count; i < num; i++ {
                var roomModel: JSON = roomModels[i]
                self.chats.append(ChatRoomModel(json: roomModel))
            }
            
            callback(self.chats)
            }, error: {error in
                println("チャットルームリスト読み込み失敗")
        })
    }
    
    // ID から ChatRoomModel を取得する
    func getRoomModelById(roomId: Int) -> ChatRoomModel?{
        var modelList = chats.filter({$0.roomId == roomId})
        
        // 取得できなかった場合
        if (modelList.count == 0) {
            println("指定した roomId: \(roomId) のモデルを取得できませんでした")
            return nil
        }
        
        return modelList[0]
    }
    
    // ID から ChatRoom のメンバーリストを取得する
    func getRoomMembersById(roomId: Int, callback: (AnyObject?) -> ()) {
        apiManager.getRoomMembers(roomId, success: {responseData in
            let memberModels: JSON = responseData.json(error:nil)!
            var members: Array<ContactModel> = []
            
            for var i = 0, num = memberModels.arrayValue?.count; i < num; i++ {
                var memberModel: JSON = memberModels[i]
                members.append(ContactModel(json: memberModel))
            }
            
            callback(members)
        }, error: {error in
            println("roomId: \(roomId) のチャットルームメンバーリスト読み込み失敗")
        })
    }
}
