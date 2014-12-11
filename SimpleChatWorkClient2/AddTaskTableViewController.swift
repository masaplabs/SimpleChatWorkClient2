//
//  AddTaskTableViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/30.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class AddTaskTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    let viewModel: AddTaskTableViewModel = AddTaskTableViewModel.sharedInstance
    let tableViewCellIdentifier = "cell"
    
    var navigationBar: UINavigationBar = UINavigationBar()
    var addTaskTableView: UITableView?
    var taskBodyTextView: UITextView?
    var tapGesture: UITapGestureRecognizer? = nil
    
    var roomId: Int!
    var assigneeCell: AssginToTableViewCell?
    var selectedMemberIds: [Int] = []
    var selectedDateTime: Int = 0
    
    // MARK: - Init
    
    convenience init(roomId: Int!) {
        self.init(nibName: nil, bundle: nil)
        self.roomId = roomId
        
        title = NSLocalizedString("Add Task", value: "Add Task", comment: "タスク追加")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        
        // 閉じるボタン
        let closeButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Close", value: "Close", comment: "閉じる"), style: UIBarButtonItemStyle.Bordered, target: self, action: "closeView")
        navigationItem.leftBarButtonItem = closeButton
        
        // 送信ボタン
        let sendButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Send", value: "Send", comment: "送信"), style: UIBarButtonItemStyle.Done, target: self, action: "sendTask")
        navigationItem.rightBarButtonItem = sendButton
        
        // TableView 作成
        addTaskTableView = UITableView(frame: CGRect(x: 0, y: navigationBar.frame.height, width: self.view.frame.width, height: self.view.frame.height), style: .Grouped)
        addTaskTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        addTaskTableView?.dataSource = self
        addTaskTableView?.delegate = self
        view.addSubview(addTaskTableView!)
        
        // タップでキーボードを閉じる
        tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture?.delegate = self
        view.addGestureRecognizer(tapGesture!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegate
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    // セクションヘッダータイトル
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return ""
        } else {
            return NSLocalizedString("Task Detail", value: "Task Detail", comment: "タスク内容")
        }
    }
    
    // セル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return 1
        }
    }
    
    // セル生成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                var cell: AssginToTableViewCell? = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as? AssginToTableViewCell
                
                if ((cell) == nil) {
                    cell = AssginToTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tableViewCellIdentifier)
                }
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                assigneeCell = cell
                
                cell!.setNeedsUpdateConstraints()
                
                return cell!
            } else {
                // Limit Date Cell を作成する
                var cell: DatePickerTableViewCell? = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as? DatePickerTableViewCell
                
                if ((cell) == nil) {
                    cell = DatePickerTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tableViewCellIdentifier)
                }
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                cell!.setNeedsUpdateConstraints()
                
                return cell!
            }
        } else if indexPath.section == 1 {
            // タスク内容記述用 TextView
            cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as? UITableViewCell
            taskBodyTextView = UITextView(frame: CGRect(x: 0, y: 0, width: cell!.contentView.frame.width, height: cell!.contentView.frame.height))
            cell?.contentView.addSubview(taskBodyTextView!)
        }
        
        return cell!
    }
    
    // セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 1 && indexPath.row == 0) {
            return 100
        } else {
            return 44
        }
    }
    
    // セルを選択した場合
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row == 0) {
            // Assign To へジャンプ
            let controller: ChooseContactTableViewController = ChooseContactTableViewController(roomId: roomId)
            controller.parentController = self
            self.navigationController?.pushViewController(controller, animated: true)
        } else if (indexPath.row == 1) {
            // ActionSheetDatePicker で DatePicker を表示する
            var datePicker = ActionSheetDatePicker(title: NSLocalizedString("Limit Date", value: "Limit Date", comment: "期限"), datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: {picker, selectedIndex, selectedValue in
                
                // 期限日を入力する
                var date: NSDate = selectedIndex as NSDate
                self.selectedDateTime = Int(date.timeIntervalSince1970)
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"

                var cell: DatePickerTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as DatePickerTableViewCell
                cell.dateLabel?.text = dateFormatter.stringFromDate(date)
                
                return
            }, cancelBlock: {ActionStringCancelBlock in
                self.selectedDateTime = 0
                
                var cell: DatePickerTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as DatePickerTableViewCell
                cell.dateLabel?.text = ""
                
                return
            }, origin: self.view)
            datePicker.showActionSheetPicker()
        }
    }
    
    // MARK: - UIGestureRecognizer Delegate
    
    // キーボードを表示しているときのみ効くようにする
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (gestureRecognizer == tapGesture) {
            if (taskBodyTextView!.isFirstResponder()) {
                return true
            } else {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - Private Method
    
    // MARK: - Event Method
    
    func updateAssigneeCell() {
        
        assigneeCell?.selectedMembers = selectedMemberIds
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // タスクを送信する
    func sendTask() -> Void {
        if (selectedMemberIds.isEmpty) {
            var alert:UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Need AssignTo", value: "Please select Members.", comment: "担当者を選択してください"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if (taskBodyTextView?.text == "") {
            var alert:UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Need Text", value: "Please input some text.", comment: "タスク内容を入力してください"), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        var assigneeLabelText: String! = nil
        for selectedId in selectedMemberIds {
            if (assigneeLabelText != nil) {
                assigneeLabelText = assigneeLabelText + ", \(selectedId)"
            } else {
                assigneeLabelText =  String(selectedId)
            }
        }
        
        viewModel.postTask(roomId, body: taskBodyTextView!.text, toIds: assigneeLabelText, limit: selectedDateTime, callback: {
            // メインスレッドで実行する必要がある
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        })
    }
    
    // View を閉じる
    func closeView() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
