//
//  TasksViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/19.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class TasksViewModel: NSObject {
    
    // MARK: - Properties
    
    var model: TaskListModel = TaskListModel.sharedInstance
    
    var tasks: Array<TaskModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: TasksViewModel {
        struct Static {
            static let instance: TasksViewModel = TasksViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // タスクリストを取得する
    func getTasks(callback:() -> Void) {
        model.getTasks({tasks in
            self.tasks = tasks as Array
            
            callback()
        })
    }
}
