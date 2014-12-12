//
//  ViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/09/25.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - Properties
    
    let apiManager: NCWAPIManager = NCWAPIManager.sharedInstance
    let meModel: MeModel = MeModel.sharedInstance
    var navigationBar: UINavigationBar = UINavigationBar()
    
    var tokenText: UITextField = UITextField()
    
    var delegate: ChatsViewControllerDelegate? = nil
    
    // TODO: やめたい
    var profileDelegate: ProfileViewControllerDelegate? = nil
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.whiteColor()
        
        // ナビゲーションバーを設置
        self.setNavigationBar()
        
        self.renderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private Method
    
    // ナビゲーションバーを設置
    func setNavigationBar() -> Void {
        let bounds: CGRect = self.view.bounds
        
        // ナビゲーションバーの初期設定
        self.navigationBar.frame = CGRectMake(0, 0, bounds.size.width, 60)
        
        // タイトルやボタンを配置する外枠
        var navigationItem: UINavigationItem = UINavigationItem(title: "SignIn")
        
        // ナビゲーションアイテムを配置する
        self.navigationBar.pushNavigationItem(navigationItem, animated: true)
        self.view.addSubview(self.navigationBar)
    }
    
    // View を描画する
    func renderView() -> Void {
        tokenText.borderStyle = UITextBorderStyle.RoundedRect
        
        var signInButton: UIButton = UIButton()
        signInButton.setTitle("SignIn", forState: .Normal)
        signInButton.setTitleColor(UIColor(rgba: "#C1251E"), forState: .Normal)
        signInButton.addTarget(self, action: "signIn", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(tokenText)
        self.view.addSubview(signInButton)
        
        tokenText.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 150.0)
        tokenText.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 40.0)
        tokenText.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 40.0)
        
        signInButton.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: tokenText, withOffset: 10.0)
        signInButton.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 40.0)
        signInButton.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 40.0)
    }
    
    // MARK: - Event Method
    
    // サインイン
    func signIn() -> Void {
        meModel.signIn(tokenText.text, callback: {
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                // ログインウインドウを閉じる
                self.dismissViewControllerAnimated(false, completion: {
                    if (self.delegate != nil) {
                        self.delegate!.getRoomAndReloadTable()
                    }
                })
            })
        })
    }
}

