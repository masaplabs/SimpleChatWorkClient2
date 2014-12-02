//
//  AssginToTableViewCell.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/06.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class AssginToTableViewCell: UITableViewCell{
    
    // MARK: - Properties
    
    var titleLabel = UILabel(forAutoLayout: ())
    var assigneeLabel = UILabel(forAutoLayout: ())
    var selectedMembers: [Int] = []
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.text = NSLocalizedString("Assign To", value: "Assign To", comment: "担当者")
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        assigneeLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        assigneeLabel.textColor = UIColor.grayColor()
        assigneeLabel.textAlignment = NSTextAlignment.Right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(assigneeLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Override
    
    override func updateConstraints() {
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5)
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 5)
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 15)
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 100)
        
        var assigneeLabelText: String! = nil
        for selectedId in selectedMembers {
            if (assigneeLabelText != nil) {
                assigneeLabelText = assigneeLabelText + ", \(selectedId)"
            } else {
                assigneeLabelText =  String(selectedId)
            }
        }
        
        assigneeLabel.text = assigneeLabelText
        
        assigneeLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5)
        assigneeLabel.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 5)
        assigneeLabel.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 200)
        assigneeLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        super.updateConstraints()
    }
}
