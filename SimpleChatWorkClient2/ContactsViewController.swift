//
//  ContactsViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/15.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {

    // MARK: - Properties
    
    let viewModel: ContactsViewModel = ContactsViewModel.sharedInstance
    let tableViewCellIdentifier = "cell"
    
    // MARK: - Init
    
    override convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Contacts", value: "Contacts", comment: "コンタクトリスト")
        
        self.tabBarItem.image = UIImage(named: "ContactTab")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TableView 作成
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        // チャットルームリスト読み込み
        viewModel.getContacts({
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
        return self.viewModel.contacts.count
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
        
        let controller: ProfileViewController = ProfileViewController(accountId: viewModel.contacts[indexPath.row].accountId)
        controller.hidesBottomBarWhenPushed = true
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private Method
    
    func updateCell(cell: RoomMembersViewCell, indexPath: NSIndexPath) {
        // モデルを持っている場合のみ
        if (viewModel.contacts.count > 0) {
            let contactModel: ContactModel = viewModel.contacts[indexPath.row]
            let title = contactModel.name
            let subtitle = contactModel.organizationName + " " + contactModel.department
            let contactIconPath = contactModel.iconPath
            let image = UIImage(named: "placeholder")
            
            cell.titleLabel?.text = title
            cell.subtitleLabel?.text = subtitle
            cell.roomIconView?.sd_setImageWithURL(NSURL(string: contactIconPath!), placeholderImage: image)
        }
    }

    // MARK: - Event Method
    
    func reloadTable() {
        self.tableView.reloadData()
        
    }
    
    // MARK: - Override UIViewControllerExtension
    
    // 最上部へスクロールする
    override func tappedTab() {
        tableView.setContentOffset(CGPoint.zeroPoint, animated: true)
    }
}
