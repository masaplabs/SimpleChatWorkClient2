//
//  ChatRoomInformationViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/10.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ChatRoomInformationViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    
    let viewModel: ChatRoomInformationViewModel = ChatRoomInformationViewModel.sharedInstance

    var roomId: Int!
    
    var tapGesture: UITapGestureRecognizer? = nil
    var roomNameLabel = UILabel(forAutoLayout: ())
    var roomNameTextField = UITextView(forAutoLayout: ())
    var iconImageDefault = UIImage(named: "placeholder.png")
    var descriptionTextField = UITextView(forAutoLayout: ())
    var closeButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var sendButton: UIBarButtonItem!
    
    // MARK: - Init
    
    convenience init(roomId: Int!) {
        self.init(nibName: nil, bundle: nil)
        self.roomId = roomId
        
        title = NSLocalizedString("Information", value: "Information", comment: "チャットルーム概要")
        
        closeButton = UIBarButtonItem(title: NSLocalizedString("Close", value: "Close", comment: "閉じる"), style: UIBarButtonItemStyle.Bordered, target: self, action: "closeView")
        editButton = UIBarButtonItem(title: NSLocalizedString("Edit", value: "Edit", comment: "編集"), style: UIBarButtonItemStyle.Bordered, target: self, action: "editView")
        cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", value: "Cancel", comment: "キャンセル"), style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelEdit")
        sendButton = UIBarButtonItem(title: NSLocalizedString("Done", value: "Done", comment: "決定"), style: UIBarButtonItemStyle.Done, target: self, action: "sendInformation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        // 閉じるボタン
        navigationItem.leftBarButtonItem = closeButton
        
        // チャットルーム詳細情報を取得
        viewModel.getDetail(roomId, callback: {
            if (self.viewModel.isAdmin()) {
                self.navigationItem.rightBarButtonItem = self.editButton
            }
            
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                self.renderView()
            })
        })
        
        // タップでキーボードを閉じる
        tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture?.delegate = self
        view.addGestureRecognizer(tapGesture!)
        
        // キーボードによる高さ変更
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Method
    
    private func renderView() -> Void {
        let iconPath = viewModel.iconPath
        var iconImageView: UIImageView = UIImageView(image: iconImageDefault)
        
        // 編集用
        roomNameTextField.hidden = true
        roomNameTextField.font = UIFont(name: "HelveticaNeue", size: 14)
        roomNameTextField.layer.borderColor = UIColor.grayColor().CGColor
        roomNameTextField.layer.borderWidth = 1.0
        roomNameTextField.layer.cornerRadius = 5.0
        
        descriptionTextField.editable = false
        descriptionTextField.font = UIFont(name: "HelveticaNeue", size: 14)
        descriptionTextField.layer.borderColor = UIColor.grayColor().CGColor
        descriptionTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.cornerRadius = 5.0
        
        view.addSubview(roomNameTextField)
        view.addSubview(roomNameLabel)
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
        
        roomNameLabel.autoSetDimension(ALDimension.Height, toSize: 50)
        roomNameLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: iconImageView)
        roomNameLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: iconImageView, withOffset: 10)
        roomNameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        descriptionTextField.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: iconImageView, withOffset: 10)
        descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 10)
        descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 10)
        
        // 値を入れる
        iconImageView.sd_setImageWithURL(NSURL(string: iconPath!), completed: { (image, error, type, url) -> Void in
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
        })
        
        roomNameLabel.text = viewModel.roomName
        descriptionTextField.text = viewModel.roomDescription
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
    
    // MARK: - Event Method
    
    // View を閉じる
    func closeView() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 編集モードにする
    func editView() -> Void {
        roomNameTextField.text = viewModel.roomName
        roomNameLabel.hidden = true
        roomNameTextField.hidden = false
        descriptionTextField.editable = true
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = sendButton
        
        roomNameTextField.becomeFirstResponder()
    }
    
    // 編集モードをキャンセルする
    func cancelEdit() {
        roomNameLabel.hidden = false
        roomNameTextField.hidden = true
        descriptionTextField.editable = false
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = editButton
        
        roomNameTextField.resignFirstResponder()
    }
    
    // 変更内容を送信する
    func sendInformation() {
        // 入力チェック
        if (roomNameTextField.text == "") {
            var alert:UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Need ChatRoom Title", value: "Please input this chat room title.", comment: "チャットルームタイトルを入力してください"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        // 変更内容送信
        viewModel.putRoom(roomId, name: roomNameTextField.text, description: descriptionTextField.text, callback: {
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                // 編集を確定
                self.roomNameLabel.text = self.roomNameTextField.text

                self.roomNameLabel.hidden = false
                self.roomNameTextField.hidden = true
                self.descriptionTextField.editable = false
                
                self.navigationItem.leftBarButtonItem = self.closeButton
                self.navigationItem.rightBarButtonItem = self.editButton
                
                self.roomNameTextField.resignFirstResponder()
            })
        })
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
        
        var wself = self
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.descriptionTextField.frame = CGRectMake(self.descriptionTextField.frame.origin.x, self.descriptionTextField.frame.origin.y, self.descriptionTextField.frame.size.width, self.descriptionTextField.frame.size.height + keyboardHeight)
            }, completion: {complete in
                // TODO: AutoLayout 不具合あり 意図しない再描画が起こる
                self.descriptionTextField.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 10)
                println()
        })
    }
}
