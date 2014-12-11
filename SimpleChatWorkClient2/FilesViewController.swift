//
//  FilesViewController.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/27.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class FilesViewController: UITableViewController {
    
    // MARK: - Properties
    
    let viewModel: FilesViewModel = FilesViewModel.sharedInstance
    let tableViewCellIdentifier = "cell"
    
    var roomId: Int!
    
    // MARK: - Init
    
    convenience init(roomId: Int!) {
        self.init(nibName: nil, bundle: nil)
        
        self.roomId = roomId
        self.title = NSLocalizedString("Files", value: "Files", comment: "ファイルリスト")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 閉じるボタン
        let closeButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action: "closeView")
        navigationItem.leftBarButtonItem = closeButton
        
        // TableView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // ファイルリスト読み込み
        viewModel.getFiles(roomId, {
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
        return self.viewModel.files.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cell を作成する
        var cell : FilesTableViewCell? = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as? FilesTableViewCell
        
        if ((cell) == nil) {
            cell = FilesTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: tableViewCellIdentifier)
        }
        
        self.updateCell(cell!, indexPath: indexPath)
        
        cell!.setNeedsUpdateConstraints()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let fileId = viewModel.files[indexPath.row].fileId
        
        viewModel.getFileURLById(roomId, fileId: fileId, callback: {url in
            dispatch_async(dispatch_get_main_queue(), {
                let controller: JBWebViewController = JBWebViewController(url: NSURL(string: url))
                controller.showFromController(self, withCompletion: nil)
            })
        })
    }
    
    // MARK: - Private Method
    
    func updateCell(cell: FilesTableViewCell, indexPath: NSIndexPath) {
        // モデルを持っている場合のみ
        if (viewModel.files.count > 0) {
            let fileModel: FileModel = viewModel.files[indexPath.row]
            let fileName = fileModel.fileName
            
            let date = NSDate(timeIntervalSince1970: Double(fileModel.uploadTime))
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            
            let detail = dateFormatter.stringFromDate(date) + " / " + NCWEnvironment().byteString(fileModel.fileSize)
            let image = UIImage(named: "fileicon")
            
            cell.fileNameLabel?.text = fileName
            cell.detailLabel?.text = detail
            cell.fileIconView?.sd_setImageWithURL(NSURL(string: ""), placeholderImage: image)
            
            cell.layoutIfNeeded()
        }
    }
    
    // MARK: - Event Method
    
    func reloadTable() {
        self.tableView.reloadData()
        
    }
    
    // View を閉じる
    func closeView() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}