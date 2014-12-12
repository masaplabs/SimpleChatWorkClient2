//
//  TimelineViewModel.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/18.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class TimelineViewModel: NSObject {
   
    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    let roomListModel: ChatRoomListModel = ChatRoomListModel.sharedInstance
    let meModel: MeModel = MeModel.sharedInstance
    
    var messages: Array<MessageModel> = []
    var outgoingBubbleImageData: JSQMessageBubbleImageDataSource!
    var incomingBubbleImageData: JSQMessageBubbleImageDataSource!
    
    var chatRoomId: Int!
    var chatRoomTitle: String!
    
    var myAccountId: Int!
    
    // MARK: - Singleton
    
    class var sharedInstance: TimelineViewModel {
        struct Static {
            static let instance: TimelineViewModel = TimelineViewModel()
        }
        return Static.instance
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        let bubbleFactory: JSQMessagesBubbleImageFactory = JSQMessagesBubbleImageFactory()
        
        outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor(rgba: "#B2FF99"))
        
        myAccountId = meModel.accountId
    }
    
    // MARK: - Public Method
    
    // Timeline 詳細を取得する
    func getDetail(roomId: Int) {
        let model: ChatRoomModel! = roomListModel.getRoomModelById(roomId)
        
        chatRoomId = model.roomId
        chatRoomTitle = model.name
    }
    
    func getMessages(force: Bool, callback: () -> ()) {
        messages = []
        
        apiManager.getMessages(chatRoomId, force: force, success: {messageModels in
            // メッセージリストからメッセージモデルを作成し、 messages リストに入れていく
            for var i = 0, num = messageModels.arrayValue?.count; i < num; i++ {
                var messageModel: JSON = messageModels[i]
                let model: MessageModel = MessageModel(json: messageModel)
                
                let date = NSDate(timeIntervalSince1970: Double(model.sendDateTime))
                
                let jsq_model: JSQTextMessage = JSQTextMessage(senderId: String(model.accountId), senderDisplayName: model.name, date: date, text: model.body)
                model.jsqMessageData = jsq_model
                self.messages.append(model)
            }

            callback()
        }, error: {error in
            println("メッセージ取得失敗")
        })
    }
    
    // メッセージを送信する
    func postMessage(body: String, callback: (AnyObject!) -> ()) {
        apiManager.postMessage(chatRoomId, body: body, success: {responseData in
            // TODO: ちゃんと作ろう
            var model: MessageModel = MessageModel(json: nil)
            model.messageId = 99999999
            model.accountId = self.meModel.accountId
            model.name = self.meModel.name
            model.body = body
            model.iconPath = self.meModel.iconPath
            model.isMyMessage = true
            
            let date = NSDate()

            let jsq_model: JSQTextMessage = JSQTextMessage(senderId: String(model.accountId), senderDisplayName: model.name, date: date, text: model.body)
            model.jsqMessageData = jsq_model
            
            self.messages.append(model)
            callback(nil)
        }, error: {error in
            println("メッセージ投稿失敗")
            callback(nil)
        })
    }
}
