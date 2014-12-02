//
//  ChooseContactTableViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ChooseContactTableViewModel: NSObject {
    
    // MARK: - Properties
    
    var model: ChatRoomListModel = ChatRoomListModel.sharedInstance
    
    var members: Array<ContactModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: ChooseContactTableViewModel {
        struct Static {
            static let instance: ChooseContactTableViewModel = ChooseContactTableViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // チャットルームメンバーリストを取得する
    func getRoomMembers(roomId: Int, callback:() -> Void) {
        model.getRoomMembersById(roomId, callback: {members in
            self.members = members as Array
            
            callback()
        })
    }
}
