//
//  RoomMembersViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/21.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

enum MemberSideMenuSelectedIndex: Int {
    case AddTask,
         Information,
         Members,
         ViewTask
}

class RoomMembersViewController: UITableViewController, FrostedSidebarDelegate {
    
    // MARK: - Properties
    
    let viewModel: ChooseContactTableViewModel = ChooseContactTableViewModel.sharedInstance
    let tableViewCellIdentifier = "cell"
    
    var roomId: Int!
    
    var sideMenubar: FrostedSidebar!
    var selectedIndex = 0
    var isOpenedSideMenu = false
    
    // MARK: - Init
    
    override convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Chat Room Member", value: "Chat Room Member", comment: "メンバー")
    }
    
    // 引数ありの場合
    convenience init(roomId: Int!) {
        self.init()
        self.roomId = roomId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 閉じるボタン
        let closeButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action: "closeView")
        navigationItem.leftBarButtonItem = closeButton
        
        // TODO: サイドメニューは機能が重いためあとで実装
        var infoButton = UIBarButtonItem(image: UIImage(named: "typing"), style: .Plain, target: self, action: "openSideMenu")
//        self.navigationItem.rightBarButtonItem = infoButton
        
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
        
        // TableView 作成
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        
        viewModel.getRoomMembers(roomId, callback: {
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadTable()
            })
        })
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
        return self.viewModel.members.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cell を作成する
        var cell : RoomMembersViewCell? = self.tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as? RoomMembersViewCell
        
        if ((cell) == nil) {
            cell = RoomMembersViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tableViewCellIdentifier)
        }
        
        self.updateCell(cell!, indexPath: indexPath)
        
        cell!.setNeedsUpdateConstraints()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller: ProfileViewController = ProfileViewController(accountId: viewModel.members[indexPath.row].accountId)
        controller.hidesBottomBarWhenPushed = true
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private Method
    
    func updateCell(cell: RoomMembersViewCell, indexPath: NSIndexPath) {
        // モデルを持っている場合のみ
        if (viewModel.members.count > 0) {
            let contactModel: ContactModel = viewModel.members[indexPath.row]
            let title = contactModel.name
            let subtitle = contactModel.organizationName + " " + contactModel.department
            let contactIconPath = contactModel.iconPath
            let image = UIImage(named: "placeholder")
            
            if ((contactModel.accountId) != nil) {
                cell.accountId = contactModel.accountId
            }
            
            cell.titleLabel?.text = title
            cell.subtitleLabel?.text = subtitle
            cell.roomIconView?.sd_setImageWithURL(NSURL(string: contactIconPath!), placeholderImage: image)
        }
    }
    
    // MARK: - FrostedSidebarDelegate
    
    func sidebar(sidebar: FrostedSidebar, didShowOnScreenAnimated animated: Bool) {
        isOpenedSideMenu = true
    }
    
    func sidebar(sidebar: FrostedSidebar, didDismissFromScreenAnimated animated: Bool) {
        isOpenedSideMenu = false
    }
    
    func sidebar(sidebar: FrostedSidebar, didTapItemAtIndex index: Int) {
        let selectedIndex = MemberSideMenuSelectedIndex(rawValue: index)
        if let selected = selectedIndex {
            switch selected {
            case .AddTask:
                // タスク追加画面表示
                sideMenubar.dismissAnimated(true, completion: {finished in
//                    let controller = UINavigationController(rootViewController: AddTaskTableViewController(roomId: self.viewModel.chatRoomId))
//                    
//                    self.presentViewController(controller, animated: true, completion: nil)
                })
            case .Information:
                // チャットルーム概要表示
                sideMenubar.dismissAnimated(true, completion: {finished in
                })
            case .Members:
                // メンバー一覧表示
                sideMenubar.dismissAnimated(true, completion: {finished in
                })
            case .ViewTask:
                // タスク一覧表示
                sideMenubar.dismissAnimated(true, completion: {finished in
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
    
    // MARK: - Event Method
    
    func reloadTable() {
        self.tableView.reloadData()
        
    }
    
    // View を閉じる
    func closeView() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // サイドメニューを開く
    func openSideMenu() -> Void {
        if (!isOpenedSideMenu) {
            sideMenubar.showInViewController(self, animated: true)
        } else {
            sideMenubar.dismissAnimated(true, completion: nil)
        }
    }
}
