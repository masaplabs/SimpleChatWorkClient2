//
//  DatePickerTableViewCell.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/05.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell{
    
    // MARK: - Properties
    
    var titleLabel = UILabel(forAutoLayout: ())
    var dateLabel = UILabel(forAutoLayout: ())
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.text = NSLocalizedString("Limit Date", value: "Limit Date", comment: "期限")
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        dateLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        dateLabel.textColor = UIColor.grayColor()
        dateLabel.textAlignment = NSTextAlignment.Right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
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
        
        dateLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5)
        dateLabel.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 5)
        dateLabel.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 200)
        dateLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        super.updateConstraints()
    }
}
