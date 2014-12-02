//
//  ProfileViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/15.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit
import QuartzCore

protocol ProfileViewControllerDelegate {
    func selectRootTab()
}

class ProfileViewController: UIViewController, ProfileViewControllerDelegate {
    
    // MARK: - Properties
    
    var viewModel: ProfileViewModel = ProfileViewModel.sharedInstance
    
    var nameLabel = UILabel(forAutoLayout: ())
    var companyLabel = UILabel(forAutoLayout: ())
    var chatWorkIdLabel = UILabel(forAutoLayout: ())
    var introductionLabel = UILabel(forAutoLayout: ())
    let coverImageDefault = UIImage(named: "cover_blue")
    var iconImageDefault = UIImage(named: "placeholder")
    
    var accountId: Int?

    // MARK: - Init
    
    // 引数なしの場合
    override convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = NSLocalizedString("My", value: "My", comment: "自分の情報")
        
        self.tabBarItem.image = UIImage(named: "MyTab")
    }
    
    // 引数ありの場合
    convenience init(accountId: Int?) {
        self.init()
        
        if ((accountId) != nil) {
            self.accountId = accountId
            
            if (viewModel.hasModel(accountId!)) {
                viewModel.getModel(accountId!)
                
                // モデルを持っている場合はタイトルを上書き
                title = viewModel.name
            } else {
                title = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        if (viewModel.accountId == nil) {
            // サインアウトボタンは My タブを開いているときだけ表示する
            var signoutButton = UIBarButtonItem(title: "Signout", style: .Plain, target: self, action: "openSignInView")
            self.navigationItem.rightBarButtonItem = signoutButton
            
            // 自分の情報を取得
            if ((accountId) == nil) {
                viewModel.getMyModel()
                self.renderView()
            } else {
                // コンタクトリスト未取得のためモデルリストを取得してから描画する
                viewModel.getModelByIdWithContactList(accountId!, callback: {
                    self.title = self.viewModel.name
                    
                    self.renderView()
                })
            }
        } else {
            self.renderView()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        accountId = nil
        viewModel.clearModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Method
    
    func renderView() {
        var coverImageView: UIImageView = UIImageView(image: coverImageDefault)
        let iconPath = viewModel.iconPath
        var iconImageView: UIImageView = UIImageView(image: iconImageDefault)
        
        view.addSubview(coverImageView)
        view.addSubview(iconImageView)
        view.addSubview(nameLabel)
        view.addSubview(companyLabel)
        view.addSubview(chatWorkIdLabel)
        view.addSubview(introductionLabel)
        
        // AutoLayout 調整
        
        // カバー画像のサイズを指定
        coverImageView.autoSetDimensionsToSize(CGSizeMake(self.view.bounds.size.width, 120))
        
        // 親 View の Top にくっつける
        coverImageView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        
        // アイコンのサイズを指定
        iconImageView.autoSetDimensionsToSize(CGSizeMake(65, 65))
        
        // アイコンの Top を カバー画像の Bottom から -20 の位置に配置
        iconImageView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: coverImageView, withOffset: -20.0)
        
        // アイコンの Left を親 View から 20 の位置に配置
        iconImageView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 20.0)
        
        nameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 20)
        nameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 20)
        nameLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: iconImageView, withOffset: 10)
        
        companyLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 20)
        companyLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 20)
        companyLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: nameLabel, withOffset: 5)
        
        chatWorkIdLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 20)
        chatWorkIdLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 20)
        chatWorkIdLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: companyLabel, withOffset: 5)
        
        introductionLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 20)
        introductionLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 20)
        introductionLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: chatWorkIdLabel, withOffset: 10)
        
        // 値を入れる
        coverImageView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: coverImageDefault)
        
        nameLabel.text = viewModel.name
        companyLabel.text = viewModel.organizationName + " " + viewModel.department
        companyLabel.font = UIFont(name: companyLabel.font.fontName, size: 14)
        companyLabel.textColor = UIColor.grayColor()
        chatWorkIdLabel.text = "@" + viewModel.chatworkId
        chatWorkIdLabel.font = UIFont(name: chatWorkIdLabel.font.fontName, size: 14)
        chatWorkIdLabel.textColor = UIColor.grayColor()
        introductionLabel.text = viewModel.introduction
        introductionLabel.font = UIFont(name: chatWorkIdLabel.font.fontName, size: 16)
        introductionLabel.numberOfLines = 0
        introductionLabel.sizeToFit()
        
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
        
        // 白フチ＆影を付けたい場合はこちら
        //        var layer: CALayer = iconImageView.layer
        //        layer.shadowPath = UIBezierPath(rect: layer.bounds).CGPath
        //        layer.shouldRasterize = true
        //        layer.rasterizationScale = UIScreen.mainScreen().scale
        //        layer.borderColor = UIColor.whiteColor().CGColor
        //        layer.borderWidth = 2.0
        //        layer.shadowColor = UIColor.grayColor().CGColor
        //        layer.shadowOpacity = 0.4
        //        layer.shadowOffset = CGSizeMake(2, 3)
        //        layer.shadowRadius = 1.5
        //        iconImageView.clipsToBounds = false
    }
    
    // MARK: - Event Method
    
    func openSignInView() {
        // ログイン情報を削除
        KeychainService.delete("LoginToken")
        
        // ログイン画面を開く
        let controller: SignInViewController = SignInViewController()
        controller.view.backgroundColor = UIColor.whiteColor()
        controller.profileDelegate = self
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        controller.hidesBottomBarWhenPushed = true
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - ProfileViewControllerDelegate
    
    func selectRootTab() {
        self.navigationController?.tabBarController?.selectedIndex = 0
    }
}
