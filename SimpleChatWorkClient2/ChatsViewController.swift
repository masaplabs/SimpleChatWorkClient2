//
//  ChatsViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/09/25.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

protocol ChatsViewControllerDelegate {
    func getRoomAndReloadTable()
}

class ChatsViewController: UITableViewController, ChatsViewControllerDelegate {

    // MARK: - Properties
    
    let viewModel: ChatsViewModel = ChatsViewModel.sharedInstance
    let tableViewCellIdentifier = "cell"

    var whiteView: UIView!
    
    // MARK: - Init
    
    override convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Chats", comment: "チャットリスト")
        
        self.tabBarItem.image = UIImage(named: "ChatTab")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addChatRoom")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 初回表示は画面を真っ白にしておく
        if (viewModel.isFirstLoad) {
            // 最前面のコントローラー
            var topController: UIViewController! = UIApplication.sharedApplication().keyWindow?.rootViewController
            whiteView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height + 60))
            whiteView.backgroundColor = UIColor.whiteColor()
            topController.view.addSubview(whiteView)
            
            viewModel.isFirstLoad = false
        }
        
        
        // TableView 作成
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        if (NCWEnvironment().isLogin()) {
            // ローディング画面表示
            let controller: LoadingViewController = LoadingViewController()
            
            self.presentViewController(controller, animated: false, completion: {
                self.whiteView.removeFromSuperview()
            })
            
            // チャットルームリスト読み込み
            getRoomAndReloadTable()
        } else {
            // ログイン画面表示
            let controller: SignInViewController = SignInViewController()
            controller.delegate = self
            self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            controller.hidesBottomBarWhenPushed = true
            
            self.presentViewController(controller, animated: true, completion: {
                self.whiteView.removeFromSuperview()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 表示する行数
        return self.viewModel.chats.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cell を作成する
        var cell: ChatsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as? ChatsTableViewCell
        
        if ((cell) == nil) {
            cell = ChatsTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tableViewCellIdentifier)
        }
        
        self.updateCell(cell!, indexPath: indexPath)
        
        cell!.setNeedsUpdateConstraints()
      
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller: TimelineViewController = TimelineViewController(roomId: viewModel.chats[indexPath.row].roomId)
        controller.hidesBottomBarWhenPushed = true
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private Method
    
    // チャットルームリストを取得して TableView をリロードする ChatsViewControllerDelegate も兼ねていて AddChatRoomViewController からも呼び出し可能
    func getRoomAndReloadTable() {
        // getRooms に成功すると viewModel.chats（チャットルームリスト）が取得される
        viewModel.getRooms({
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadTable()
            })
        })
    }
    
    func updateCell(cell: ChatsTableViewCell, indexPath: NSIndexPath) {
        // モデルを持っている場合のみ
        if (viewModel.chats.count > 0) {
            let roomModel: ChatRoomModel = viewModel.chats[indexPath.row]
            let title = roomModel.name
            let roomIconPath = roomModel.iconPath
            let image = UIImage(named: "placeholder")
            
            cell.titleLabel?.text = title
            cell.subtitleLabel?.text = "Subtitle No. \(indexPath.row)"
            cell.roomIconView?.sd_setImageWithURL(NSURL(string: roomIconPath!), placeholderImage: image)
        }
    }
    
    // MARK: - Event Method
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    // 新規チャット追加
    func addChatRoom() {
        var rootViewController = AddChatRoomViewController()
        rootViewController.delegate = self
        var controller = UINavigationController(rootViewController: rootViewController)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Override UIViewControllerExtension
    
    // 最上部へスクロールする
    override func tappedTab() {
        tableView.setContentOffset(CGPoint.zeroPoint, animated: true)
    }
}
