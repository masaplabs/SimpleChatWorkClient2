//
//  ChooseContactTableViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/04.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class ChooseContactTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let viewModel: ChooseContactTableViewModel = ChooseContactTableViewModel.sharedInstance
    let tableViewCellIdentifier = "cell"

    var roomId: Int!
    
    var parentController: AddTaskTableViewController!
    
    // MARK: - Init
    
    override convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Assign To", comment: "担当者")
    }
    
    // 引数ありの場合
    convenience init(roomId: Int!) {
        self.init()
        self.roomId = roomId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        var cell : ChatsTableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as? ChatsTableViewCell
        
        if ((cell) == nil) {
            cell = ChatsTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tableViewCellIdentifier)
        }
        
        self.updateCell(cell!, indexPath: indexPath)
        
        cell!.setNeedsUpdateConstraints()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var cell: ChatsTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as ChatsTableViewCell
        if let i = find(parentController.selectedMemberIds, cell.accountId!) {
            parentController.selectedMemberIds.removeAtIndex(i)
            cell.accessoryType = .None
        } else {
            parentController.selectedMemberIds.append(cell.accountId!)
            cell.accessoryType = .Checkmark
        }
        
        parentController.updateAssigneeCell()
    }
    
    // MARK: - Private Method
    
    func updateCell(cell: ChatsTableViewCell, indexPath: NSIndexPath) {
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
            
            if let i = find(parentController.selectedMemberIds, cell.accountId!) {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
    }
    
    // MARK: - Event Method
    
    func reloadTable() {
        self.tableView.reloadData()
        
    }
}
