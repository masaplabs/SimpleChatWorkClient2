//
//  FilesViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/27.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class FilesViewModel: NSObject {
    
    // MARK: - Properties
    
    var model: FileListModel = FileListModel.sharedInstance
    
    var files: Array<FileModel> = []
    
    // MARK: - Singleton
    
    class var sharedInstance: FilesViewModel {
        struct Static {
            static let instance: FilesViewModel = FilesViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    // MARK: - Public Method
    
    // ファイルリストを取得する
    func getFiles(roomId: Int, callback: () -> Void) {
        model.getFiles(roomId, {files in
            self.files = files as Array
            
            callback()
        })
    }
    
    // ファイルダウンロードURLを取得する
    func getFileURLById(roomId: Int, fileId: Int, callback: (String) -> Void) {
        model.getFileURLById(roomId, fileId: fileId, callback: {url in
            callback(url)
        })
    }
}
