//
//  ChatsTableViewCell.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/10/08.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var parentController: TasksViewController?
    
    var taskBody = UILabel(forAutoLayout: ())
    var assignedByName = UILabel(forAutoLayout: ())
    var roomName = UILabel(forAutoLayout: ())
    var roomIconView = UIImageView(forAutoLayout: ())
    var completeButton = UILabel(forAutoLayout: ())
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // タスク本文設定
        taskBody.font = UIFont(name: "HelveticaNeue", size: 14)
        taskBody.numberOfLines = 0
        
        // 依頼者設定
        assignedByName.font = UIFont(name: "HelveticaNeue", size: 12)
        assignedByName.textColor = UIColor.grayColor()
        
        // チャットルーム名設定
        roomName.font = UIFont(name: "HelveticaNeue", size: 12)
        roomName.textColor = UIColor.grayColor()
        
        // チャットルームアイコン設定
        let image = UIImage(named: "placeholder.png")
        roomIconView = UIImageView(image: image)
        
        // 完了ボタン
        completeButton.text = NSLocalizedString("Complete", value: "Complete", comment: "完了")
        completeButton.font = UIFont(name: "HelveticaNeue", size: 14)
        completeButton.textColor = UIColor.blueColor()
        
        // SubView にセットする
        contentView.addSubview(taskBody)
        contentView.addSubview(assignedByName)
        contentView.addSubview(roomName)
        contentView.addSubview(roomIconView)
        contentView.addSubview(completeButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Override
    
    override func updateConstraints() {
        // 親 View の Top から 5px 離す
        taskBody.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5.0)
        
        // 左右の端から 20px 離す
        taskBody.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 20.0)
        taskBody.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 20.0)
            
        // taskBody から 10px 離す
        assignedByName.autoSetDimension(ALDimension.Height, toSize: 20)
        assignedByName.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.taskBody, withOffset: 10.0)
        assignedByName.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 20.0)
        assignedByName.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 20.0)
            
        // assignedByName から 10px 離す
        roomIconView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.assignedByName, withOffset: 10.0)

        // 左から 20px 離す
        roomIconView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 20.0)
            
        // 大きさを 20px x 20px に設定する
        roomIconView.autoSetDimensionsToSize(CGSizeMake(20.0, 20.0))
            
        // assignedByName から 10px 離す
        roomName.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.assignedByName, withOffset: 10.0)
            
        // roomIconView から 10px 離す
        roomName.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: self.roomIconView, withOffset: 10.0)
        
        // 右から50px 離す
        roomName.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 50.0)
            
        completeButton.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.assignedByName, withOffset: 10.0)
        completeButton.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 10.0)
            
        // 親 View の Bottom に対して 20px 離す
        completeButton.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 10.0)
        
        super.updateConstraints()
    }
    
    // MARK - Public Method
    
    func addCompleteEvent(target: AnyObject!) {
        var tap = UITapGestureRecognizer(target: target, action: "completeTask")
        completeButton.userInteractionEnabled = true
        completeButton.addGestureRecognizer(tap)
    }
}
