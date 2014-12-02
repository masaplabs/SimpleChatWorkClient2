//
//  ChatRoomInformationViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ChatRoomInformationViewModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    let roomListModel: ChatRoomListModel = ChatRoomListModel.sharedInstance
    
    var roomName: String! = ""
    var roomDescription: String! = ""
    var role: String! = ""
    var iconPath: String! = ""
    
    // MARK: - Singleton
    
    class var sharedInstance: ChatRoomInformationViewModel {
        struct Static {
            static let instance: ChatRoomInformationViewModel = ChatRoomInformationViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // Timeline 詳細を取得する
    func getDetail(roomId: Int, callback: () -> Void) {
        var model: ChatRoomModel! = roomListModel.getRoomModelById(roomId)
        
        roomName = model.name
        role = model.role
        iconPath = model.iconPath
        
        apiManager.getRoomDetail(roomId,{responseData in
            let roomModel: JSON = responseData.json(error:nil)!
            model.roomDescription = roomModel["description"].stringValue
            
            self.roomDescription = model.roomDescription
            
            callback()
        }, error: {error in
            println("チャットルーム情報読み込み失敗")
            callback()
        })
    }
    
    // Admin ユーザーか
    func isAdmin() -> Bool {
        return role == "admin"
    }
    
    // チャットルーム編集
    func putRoom(roomId: Int, name: String, description: String, callback: () -> Void) {
        apiManager.putRoom(roomId, name: name, description: description, success: {responseData in
            var model: ChatRoomModel! = self.roomListModel.getRoomModelById(roomId)
            model.name = name
            model.roomDescription = description
            
            callback()
        }, error: {error in
            println("チャットルーム編集に失敗しました")
        })
    }
    func postRoom(text: String, description: String, adminIds: String, memberIds: String, callback: () -> Void) {
        apiManager.postRoom(text, description: description, adminIds: adminIds, memberIds: "", success: {responseData in
            callback()
            }, error: {error in
                println("新規チャットルーム作成に失敗しました")
        })
    }
}
