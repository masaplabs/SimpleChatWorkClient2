//
//  NCWAPIManager.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/09/29.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import Foundation

class NCWAPIManager {
    
    var httpClient: NCWHttpClient!
    
    typealias SuccessHandler = (JSON!) -> ()
    typealias FailureHandler = (NSError!) -> ()

    // シングルトンパターン
    class var sharedInstance: NCWAPIManager {
        struct Static {
            static let instance: NCWAPIManager = NCWAPIManager()
        }
        return Static.instance
    }
    
    init() {
        httpClient = NCWHttpClient()
    }
    
    // SignIn
    func signIn(token: NSString, success: SuccessHandler, error: FailureHandler) {
        httpClient.setAPIToken(token)
        self.getRequest("me", params: nil, success: success, error: error)
    }
    
    // MARK: - GET
    
    // チャットルームリスト取得
    func getRooms(success: SuccessHandler, error: FailureHandler) {
        self.getRequest("rooms", params: nil, success: success, error: error)
    }
    
    // コンタクトリスト取得
    func getContacts(success: SuccessHandler, error: FailureHandler) {
        self.getRequest("contacts", params: nil, success: success, error: error)
    }
    
    // タスクリスト取得
    func getTasks(success: SuccessHandler, error: FailureHandler) {
        self.getRequest("my/tasks", params: ["status": "open"], success: success, error: error)
    }
    
    // ファイルリスト取得
    func getFiles(roomId: Int, success: SuccessHandler, error: FailureHandler) {
        self.getRequest("rooms/\(roomId)/files", params: nil, success: success, error: error)
    }
    
    // 自分の情報を取得
    func getMy(success: SuccessHandler, error: FailureHandler) {
        self.getRequest("me", params: nil, success: success, error: error)
    }
    
    // メンバー取得
    func getRoomMembers(roomId: Int, success: SuccessHandler, error: FailureHandler) {
        self.getRequest("rooms/\(roomId)/members", params: nil, success: success, error: error)
    }
    
    // チャットルーム情報取得
    func getRoomDetail(roomId: Int, success: SuccessHandler, error: FailureHandler) {
        self.getRequest("rooms/\(roomId)", params: nil, success: success, error: error)
    }
    
    // ファイルのダウンロードURL取得
    func getFileURLById(roomId: Int, fileId: Int, success: SuccessHandler, error: FailureHandler) {
        self.getRequest("rooms/\(roomId)/files/\(fileId)", params: ["create_download_url": 1], success: success, error: error)
    }
    
    // メッセージ取得
    func getMessages(roomId: Int, force: Bool, success: SuccessHandler, error: FailureHandler) {
        self.getRequest("rooms/\(roomId)/messages", params: ["force": Int(force)], success: success, error: error)
    }
    
    // MARK: - POST
    
    // 新規チャットルーム作成
    func postRoom(name: String, description: String, adminIds: String, memberIds: String, success: SuccessHandler, error: FailureHandler) {
        self.postRequest("rooms", params: [
            "name": name,
            "description": description,
            "icon_preset": "group",
            "members_admin_ids": adminIds,
            "members_member_ids": memberIds,
            "member_readonly_ids": ""
        ], success: success, error: error)
    }
    
    // メッセージ投稿
    func postMessage(roomId: Int, body: String, success: SuccessHandler, error: FailureHandler) {
        self.postRequest("rooms/\(roomId)/messages", params: ["body": body], success: success, error: error)
    }
    
    // タスク追加
    func postTask(roomId: Int, body: String, toIds: String, limit: Int, success: SuccessHandler, error: FailureHandler) {
        self.postRequest("rooms/\(roomId)/tasks", params: ["body": body, "to_ids": toIds, "limit": limit], success: success, error: error)
    }
    
    // MARK: - PUT
    
    // チャットルーム編集
    func putRoom(roomId: Int, name: String, description: String, success: SuccessHandler, error: FailureHandler) {
        self.putRequest("rooms/\(roomId)", params: ["name": name, "description": description], success: success, error: error)
    }
    
    // MARK: - Private Method
    
    private func getRequest(apiString: String, params: [String: AnyObject]?, success: SuccessHandler, error: FailureHandler) {
        httpClient.GET(apiString, params: params, successHandler: success, failureHandler: error)
    }
    
    private func postRequest(apiString: String, params: [String: AnyObject]?, success: SuccessHandler, error: FailureHandler) {
        httpClient.POST(apiString, params: params, successHandler: success, failureHandler: error)
    }
    
    private func putRequest(apiString: String, params: [String: AnyObject]?, success: SuccessHandler, error: FailureHandler) {
        httpClient.PUT(apiString, params: params, successHandler: success, failureHandler: error)
    }
}