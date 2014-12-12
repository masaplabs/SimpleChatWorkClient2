//
//  TaskListModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class TaskListModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    var tasks: Array<TaskModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: TaskListModel {
        struct Static {
            static let instance: TaskListModel = TaskListModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // タスクリストを取得する
    func getTasks(callback: (AnyObject?) -> ()) {
        // append するため最初に空にする
        tasks = []
        
        apiManager.getTasks({taskModels in
            // タスクリストからタスクモデルを作成し、 tasks リストに入れていく
            for var i = 0, num = taskModels.arrayValue?.count; i < num; i++ {
                var taskModel: JSON = taskModels[i]
                self.tasks.append(TaskModel(json: taskModel))
            }
            
            callback(self.tasks)
        }, error: {error in
            println("タスクリスト読み込み失敗")
        })
    }
}
