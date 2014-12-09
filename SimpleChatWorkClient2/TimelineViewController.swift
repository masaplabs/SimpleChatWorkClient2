//
//  TimelineViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/10.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

enum SideMenuSelectedIndex: Int {
    case AddTask,
         Information,
         Members,
         ViewTask
}

class TimelineViewController: JSQMessagesViewController ,FrostedSidebarDelegate {

    // MARK: - Properties
    
    let viewModel: TimelineViewModel = TimelineViewModel.sharedInstance
    
    var sideMenubar: FrostedSidebar!
    var selectedIndex = 0
    var isOpenedSideMenu = false
    
    // MARK: - Init
    
    convenience init(roomId: Int) {
        self.init(nibName: nil, bundle: nil)
        
        viewModel.getDetail(roomId)
        self.title = viewModel.chatRoomTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
  
        var infoButton = UIBarButtonItem(image: UIImage(named: "typing"), style: .Plain, target: self, action: "openSideMenu")
        self.navigationItem.rightBarButtonItem = infoButton
        
        // サイドメニュー
        sideMenubar = FrostedSidebar(itemImages: [
            UIImage(named: "star")!,
            UIImage(named: "gear")!,
            UIImage(named: "profile")!,
            UIImage(named: "globe")!,
        ], colors: [
            UIColor(red: 255/255, green: 137/255, blue: 167/255, alpha: 1),
            UIColor(red: 255/255, green: 137/255, blue: 167/255, alpha: 1),
            UIColor(red: 255/255, green: 137/255, blue: 167/255, alpha: 1),
            UIColor(red: 255/255, green: 137/255, blue: 167/255, alpha: 1)
        ], selectedItemIndices: NSIndexSet(index: 0))
        sideMenubar.calloutsAlwaysSelected = true
        sideMenubar.showFromRight = true
        sideMenubar.delegate = self
        
        // タイムライン設定
        self.showLoadEarlierMessagesHeader = true
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "HelveticaNeue", size: 14)
        
        // 自分自身の ID を指定（アバター表示に必要）
        self.senderId = String(viewModel.myAccountId)
        
        // タイムライン取得
        viewModel.getMessages(true, callback: {
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadTable()
                self.scrollToBottomAnimated(false)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - JSQMessagesViewController Override
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        viewModel.postMessage(text, callback: {response in
            // 投稿完了後の処理
            dispatch_async(dispatch_get_main_queue(), {
                self.finishSendingMessage()
            })
        })
    }
    
    // MARK: - FrostedSidebarDelegate
    
    func sidebar(sidebar: FrostedSidebar, didShowOnScreenAnimated animated: Bool) {
        isOpenedSideMenu = true
    }
    
    func sidebar(sidebar: FrostedSidebar, didDismissFromScreenAnimated animated: Bool) {
        isOpenedSideMenu = false
    }
    
    func sidebar(sidebar: FrostedSidebar, didTapItemAtIndex index: Int) {
        let selectedIndex = SideMenuSelectedIndex(rawValue: index)
        if let selected = selectedIndex {
            switch selected {
            case .AddTask:
                // タスク追加画面表示
                sideMenubar.dismissAnimated(true, completion: {finished in
                    let controller = UINavigationController(rootViewController: AddTaskTableViewController(roomId: self.viewModel.chatRoomId))
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            case .Information:
                // チャットルーム概要表示
                sideMenubar.dismissAnimated(true, completion: {finished in
                    let controller = UINavigationController(rootViewController: ChatRoomInformationViewController(roomId: self.viewModel.chatRoomId))
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            case .Members:
                // メンバーリスト表示
                sideMenubar.dismissAnimated(true, completion: {finished in
                    let controller = UINavigationController(rootViewController: RoomMembersViewController(roomId: self.viewModel.chatRoomId))
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            case .ViewTask:
                // ファイルリスト表示
                sideMenubar.dismissAnimated(true, completion: {finished in
                    let controller = UINavigationController(rootViewController: FilesViewController(roomId: self.viewModel.chatRoomId))
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }
        }
    }

    func sidebar(sidebar: FrostedSidebar, didEnable itemEnabled: Bool, itemAtIndex index: Int) {
    }
    func sidebar(sidebar: FrostedSidebar, willShowOnScreenAnimated animated: Bool) {
    }
    func sidebar(sidebar: FrostedSidebar, willDismissFromScreenAnimated animated: Bool) {
    }
    
    // MARK: - Private Method
    
    func reloadTable() {
        self.collectionView.reloadData()
    }
    
    // サイドメニューを開く
    func openSideMenu() -> Void {
        if (!isOpenedSideMenu) {
            sideMenubar.showInViewController(self, animated: true)
        } else {
            sideMenubar.dismissAnimated(true, completion: nil)
        }
    }
    
    // MARK: - JSQMessages CollectionView DataSource
    
    // JSQMessageData モデルを返す
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return viewModel.messages[indexPath.item].jsqMessageData
    }
    
    // 自分の発言か他人の発言か
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message: MessageModel = viewModel.messages[indexPath.item]
        
        if (message.isMyMessage == true) {
            return viewModel.outgoingBubbleImageData
        }
        
        return viewModel.incomingBubbleImageData
    }
    
    // アバター設定
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message: MessageModel = viewModel.messages[indexPath.item]
        
        var incoming: Bool = true
        
        if (message.isMyMessage == true) {
            incoming = true
        }
        
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        // TODO: 非同期で読み込めるようにしないと遅い
//        let url = NSURL(string: message.iconPath)
//        let image = UIImage(data: NSData(contentsOfURL: url!)!)
//        let avatarImage: JSQMessageAvatarImageDataSource = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
//        let avatarImage = setupAvatarColor(message.name, incoming: incoming)
        let avatarImage: JSQMessageAvatarImageDataSource = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "ico_group"), diameter: diameter)
        return avatarImage
    }
    
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    // Cell 設定
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        cell.textView.textColor = UIColor.blackColor()
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName: UIColor(rgba: "#1F43DF"), NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        // TODO: エモーティコン変換
//        let message: MessageModel = viewModel.messages[indexPath.item]
//        let labelFont = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 12)!]
//        var attributedString = NSMutableAttributedString()
//        attributedString.appendAttributedString(NSAttributedString(string: message.body, attributes: labelFont))
//        var textAttachment = NSTextAttachment()
//        textAttachment.image = UIImage(named: "emo_bow")
//        attributedString.appendAttributedString(NSAttributedString(attachment: textAttachment))
//        
//        
//        cell.textView.attributedText = attributedString
        
        return cell
    }
    
    // 発言者
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message: MessageModel = viewModel.messages[indexPath.item];
        
        // Same as previous sender, skip
        if (indexPath.item > 0) {
            let previousMessage = viewModel.messages[indexPath.item - 1];
            if (previousMessage.accountId == message.accountId) {
                return nil
            }
        }
        
        return NSAttributedString(string:message.name)
    }
    
    // メッセージ間の高さ
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message: MessageModel = viewModel.messages[indexPath.item]
        
        // Same as previous sender, skip
        if (indexPath.item > 0) {
            let previousMessage = viewModel.messages[indexPath.item - 1];
            if (previousMessage.accountId == message.accountId) {
                return CGFloat(0.0)
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    func setupAvatarColor(name: String, incoming: Bool) -> JSQMessagesAvatarImage {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
//        let nameLength = countElements(name)
//        let initials : String? = name.substringToIndex(advance(sender.startIndex, min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("CW", backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        return userImage
    }
}
