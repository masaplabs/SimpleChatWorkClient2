//
//  TasksViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/17.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController {

    // MARK: - Properties
    
    let viewModel: TasksViewModel = TasksViewModel.sharedInstance
    let tableViewCellIdentifier = "cell"
    
    // MARK: - Init
    
    override convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("Tasks", value: "Tasks", comment: "タスクリスト")
        
        self.tabBarItem.image = UIImage(named: "TaskTab")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // タスクリスト読み込み
        viewModel.getTasks({
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
        return self.viewModel.tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cell を作成する
        var cell : TasksTableViewCell? = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as? TasksTableViewCell
        
        if ((cell) == nil) {
            cell = TasksTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tableViewCellIdentifier)
        }
        
        // TODO: Delegate を使用した方法にする
        cell?.addCompleteEvent(self)
        
        self.updateCell(cell!, indexPath: indexPath)
        
        cell!.setNeedsUpdateConstraints()
        
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Private Method
    
    func updateCell(cell: TasksTableViewCell, indexPath: NSIndexPath) {
        // モデルを持っている場合のみ
        if (viewModel.tasks.count > 0) {
            let taskModel: TaskModel = viewModel.tasks[indexPath.row]
            let taskBody = taskModel.body
            let assignedByName = "依頼者: " + taskModel.assignedByAccountName
            let roomName = taskModel.roomName
            let contactIconPath = taskModel.iconPath
            let image = UIImage(named: "placeholder")
            
            cell.taskBody?.text = taskBody
            cell.assignedByName?.text = assignedByName
            cell.roomName?.text = roomName
            cell.roomIconView?.sd_setImageWithURL(NSURL(string: contactIconPath!), placeholderImage: image)
            
            cell.layoutIfNeeded()
        }
    }
    
    // MARK: - Event Method
    
    func reloadTable() {
        self.tableView.reloadData()
        
    }
    
    // タスク完了
    func completeTask() {
        TWMessageBarManager.sharedInstance().showMessageWithTitle("Notification", description: "Task Complete is still being manufactured.", type: TWMessageBarMessageTypeError)
    }
    
    // MARK: - Override UIViewControllerExtension
    
    // 最上部へスクロールする
    override func tappedTab() {
        tableView.setContentOffset(CGPoint.zeroPoint, animated: true)
    }
}
