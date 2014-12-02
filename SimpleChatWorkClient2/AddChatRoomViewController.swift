//
//  AddChatRoomViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/14.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class AddChatRoomViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    // MARK: - Properties
    
    let viewModel: AddChatRoomViewModel = AddChatRoomViewModel.sharedInstance
    
    var roomId: Int!
    var selectedAdminIds: [Int] = []
    
    var tapGesture: UITapGestureRecognizer? = nil
    var roomNameTextField = UITextView(forAutoLayout: ())
    var iconImageDefault = UIImage(named: "placeholder.png")
    var descriptionTextField = UITextView(forAutoLayout: ())
    let roomNamePlaceholderText = NSLocalizedString("Need ChatRoom Title", value: "Please input this chat room title.", comment: "チャットルーム名を入力してください")
    let descriptionPlaceholderText = NSLocalizedString("Need ChatRoom Description", value: "Please input this chat room description.", comment: "チャットルーム概要を入力してください")
    
    var delegate: ChatsViewControllerDelegate!
    
    // MARK: - Init
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        title = NSLocalizedString("Add ChatRoom", value: "Add ChatRoom", comment: "チャットルーム追加")
        
        // 閉じるボタン
        let closeButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", comment: "閉じる"), style: UIBarButtonItemStyle.Bordered, target: self, action: "closeView")
        navigationItem.leftBarButtonItem = closeButton
        
        // 送信ボタン
        let sendButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Send", comment: "送信"), style: UIBarButtonItemStyle.Done, target: self, action: "sendChatRoom")
        navigationItem.rightBarButtonItem = sendButton
        
        // 各種 View を設置
        renderView()
        
        // タップでキーボードを閉じる
        tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture?.delegate = self
        view.addGestureRecognizer(tapGesture!)
        
        // キーボードによる高さ変更
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // UITextView に placeholder 相当の機能を実装する
        roomNameTextField.delegate = self
        roomNameTextField.tag = 0
        
        descriptionTextField.delegate = self
        descriptionTextField.tag = 1
        
        if (roomNameTextField.text == "") {
            textViewDidEndEditing(roomNameTextField)
        }
        
        if (descriptionTextField.text == "") {
            textViewDidEndEditing(descriptionTextField)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIGestureRecognizer Delegate
    
    // キーボードを表示しているときのみ効くようにする
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (gestureRecognizer == tapGesture) {
            if (roomNameTextField.isFirstResponder() || descriptionTextField.isFirstResponder()) {
                return true
            } else {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - Private Method
    
    private func renderView() -> Void {
        var iconImage = UIImage(named: "ico_group")
        var iconImageView: UIImageView = UIImageView(image: iconImage)
        
        roomNameTextField.font = UIFont(name: "HelveticaNeue", size: 14)
        roomNameTextField.layer.borderColor = UIColor.grayColor().CGColor
        roomNameTextField.layer.borderWidth = 1.0
        roomNameTextField.layer.cornerRadius = 5.0
        
        descriptionTextField.font = UIFont(name: "HelveticaNeue", size: 14)
        descriptionTextField.layer.borderColor = UIColor.grayColor().CGColor
        descriptionTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.cornerRadius = 5.0
        
        view.addSubview(roomNameTextField)
        view.addSubview(iconImageView)
        view.addSubview(descriptionTextField)
        
        // AutoLayout 調整
        
        iconImageView.autoSetDimensionsToSize(CGSizeMake(50, 50))
        iconImageView.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 10)
        iconImageView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 10)
        
        roomNameTextField.autoSetDimension(ALDimension.Height, toSize: 30)
        roomNameTextField.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 20)
        roomNameTextField.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: iconImageView, withOffset: 10)
        roomNameTextField.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        descriptionTextField.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: iconImageView, withOffset: 10)
        descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 10)
        descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 10)
        
        // 値を入れる
        // アイコンに縁をつける
        var iconImageSubLayer: CALayer = CALayer()
        iconImageSubLayer.frame = CGRectMake(0, 0, iconImageView.frame.size.width, iconImageView.frame.size.height)
        iconImageSubLayer.contents = self.iconImageDefault?.CGImage
        iconImageSubLayer.masksToBounds = true
        iconImageView.layer.addSublayer(iconImageSubLayer)
        iconImageSubLayer.cornerRadius = 10
        iconImageView.layer.borderWidth = 2.0
        iconImageView.layer.borderColor = UIColor.whiteColor().CGColor
        iconImageView.layer.cornerRadius = 10.0
        iconImageView.clipsToBounds = true
    }
    
    // MARK: - Event Method
    
    // タスクを送信する
    func sendChatRoom() -> Void {
        // タイトルが空、またはデフォルトのままならエラー
        if (roomNameTextField.text == "" || roomNameTextField.text == roomNamePlaceholderText) {
            var alert:UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Need ChatRoom Title", value: "Please input this chat room title.", comment: "チャットルームタイトルを入力してください"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }

        // 自分は必ず入る
        var adminIds: String! = String(viewModel.myAccountId)
        for selectedId in selectedAdminIds {
            if (adminIds != nil) {
                adminIds = adminIds + ", \(selectedId)"
            } else {
                adminIds =  String(selectedId)
            }
        }
        
        viewModel.postRoom(roomNameTextField.text, description: descriptionTextField.text, adminIds: adminIds, memberIds: "", callback: {
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: {
                    // チャットルームリストに戻ってリロードする
                    self.delegate.getRoomAndReloadTable()
                })
            })
        })
    }
    
    // View を閉じる
    func closeView() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // キーボードが現れたときに descriptionTextField の高さを変更する
    func keyboardWillShow(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        var keyboardHeight:CGFloat = keyboardSize.height
        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
        
        // TODO: この方法では AutoLayout エラーが発生するので別の方法を考える 中文：因為這個辦法發生AutoLayout的錯誤所以請考慮別的辦法
        descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 10 + keyboardHeight)
        
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.descriptionTextField.frame = CGRectMake(self.descriptionTextField.frame.origin.x, self.descriptionTextField.frame.origin.y, self.descriptionTextField.frame.size.width, self.descriptionTextField.frame.size.height - keyboardHeight)
            }, completion: nil)
        
    }
    
    // キーボードを隠したときに descriptionTextField の高さを変更する
    func keyboardWillHide(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        var keyboardHeight:CGFloat = keyboardSize.height
        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
       
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.descriptionTextField.frame = CGRectMake(self.descriptionTextField.frame.origin.x, self.descriptionTextField.frame.origin.y, self.descriptionTextField.frame.size.width, self.descriptionTextField.frame.size.height + keyboardHeight)
            }, completion: nil)
        
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(textView: UITextView) {
        // Tag によりどの UITextView かを見分ける
        if (textView.tag == 0) {
            if (roomNameTextField.text == "") {
                roomNameTextField.text = roomNamePlaceholderText
                roomNameTextField.textColor = UIColor.lightGrayColor()
            }
        } else {
            if (descriptionTextField.text == "") {
                descriptionTextField.text = descriptionPlaceholderText
                descriptionTextField.textColor = UIColor.lightGrayColor()
            }
        }
        
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.tag == 0) {
            if (roomNameTextField.text == roomNamePlaceholderText) {
                roomNameTextField.text = ""
                roomNameTextField.textColor = UIColor.blackColor()
            }
        } else {
            if (descriptionTextField.text == descriptionPlaceholderText) {
                descriptionTextField.text = ""
                descriptionTextField.textColor = UIColor.blackColor()
            }
        }
        
        textView.becomeFirstResponder()
    }
}
