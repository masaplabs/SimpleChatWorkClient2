//
//  RoomMembersViewCell.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/25.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class RoomMembersViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var titleLabel = UILabel(forAutoLayout: ())
    var subtitleLabel = UILabel(forAutoLayout: ())
    var roomIconView = UIImageView(forAutoLayout: ())
    var accountId: Int?
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
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
    
    // MARK: - Private Method
    
    func configure() {
        // タイトル設定
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        // サブタイトル設定
        subtitleLabel.font = UIFont(name: "HelveticaNeue", size: 11)
        subtitleLabel.textColor = UIColor.grayColor()
        
        // アイコン設定
        let image = UIImage(named: "placeholder.png")
        roomIconView = UIImageView(image: image)
        
        // SubView にセットする
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(roomIconView)
    }
    
    // MARK - Override
    
    override func updateConstraints() {
        roomIconView.autoSetDimensionsToSize(CGSizeMake(36, 36))
        roomIconView.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 4)
        roomIconView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 4)
        roomIconView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 4)
        
        titleLabel.autoSetDimension(ALDimension.Height, toSize: 20)
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 4)
        titleLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: roomIconView, withOffset: 4)
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        subtitleLabel.autoSetDimension(ALDimension.Height, toSize: 20)
        subtitleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 2)
        subtitleLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: roomIconView, withOffset: 4)
        subtitleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        super.updateConstraints()
    }
}