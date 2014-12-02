//
//  FileListModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/27.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class FileListModel: NSObject {
    
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    
    var files: Array<FileModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: FileListModel {
        struct Static {
            static let instance: FileListModel = FileListModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // ファイルリストを取得する
    func getFiles(roomId: Int, callback: (AnyObject?) -> ()) {
        // append するため最初に空にする
        files = []
        
        apiManager.getFiles(roomId, {responseData in
            // タスクリストからタスクモデルを作成し、 tasks リストに入れていく
            let fileModels: JSON! = responseData.json(error:nil)
            for var i = 0, num = fileModels.arrayValue?.count; i < num; i++ {
                var fileModel: JSON = fileModels[i]
                self.files.append(FileModel(json: fileModel))
            }
            
            callback(self.files)
        }, error: {error in
            println("ファイルリスト読み込み失敗")
        })
    }
    
    // ファイルダウンロードURLを取得する
    func getFileURLById(roomId: Int, fileId: Int, callback: (String) -> ()) {
        apiManager.getFileURLById(roomId, fileId: fileId, success: {responseData in
            let fileModel: JSON! = responseData.json(error:nil)
            let downloadURL: String! = fileModel["download_url"].stringValue
            
            callback(downloadURL)
        }, error: {error in
            println("ファイル読み込み失敗")
        })
    }
}
