//
//  AddTaskTableViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class AddTaskTableViewModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    // MARK: - Singleton
    
    class var sharedInstance: AddTaskTableViewModel {
        struct Static {
            static let instance: AddTaskTableViewModel = AddTaskTableViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // Timeline 詳細を取得する
    func postTask(roomId: Int, body: String, toIds: String, limit: Int, callback: () -> Void) {
        apiManager.postTask(roomId, body: body, toIds: toIds, limit: limit, success: {responseData in
            callback()
        }, error: {error in
            println("タスク追加に失敗しました")
        })
    }
}
