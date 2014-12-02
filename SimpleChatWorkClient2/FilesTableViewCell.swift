//
//  FilesTableViewCell.swift
//  SimpleChatWorkClient2
//
//  Created by 川村真史 on 2014/11/27.
//  Copyright (c) 2014年 Masafumi Kawamura. All rights reserved.
//

import UIKit

class FilesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var fileNameLabel = UILabel(forAutoLayout: ())
    var detailLabel = UILabel(forAutoLayout: ())
    var fileIconView = UIImageView(forAutoLayout: ())
    
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
        fileNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        // サブタイトル設定
        detailLabel.font = UIFont(name: "HelveticaNeue", size: 11)
        detailLabel.textColor = UIColor.grayColor()
        
        // アイコン設定
        let image = UIImage(named: "fileicon")
        fileIconView = UIImageView(image: image)
        
        // SubView にセットする
        contentView.addSubview(fileNameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(fileIconView)
    }
    
    // MARK - Override
    
    override func updateConstraints() {
        fileIconView.autoSetDimensionsToSize(CGSizeMake(24, 30))
        fileIconView.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 7)
        fileIconView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 7)
        fileIconView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 7)
        
        fileNameLabel.autoSetDimension(ALDimension.Height, toSize: 16)
        fileNameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 7)
        fileNameLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: fileIconView, withOffset: 7)
        fileNameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        detailLabel.autoSetDimension(ALDimension.Height, toSize: 14)
        detailLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: fileIconView, withOffset: 7)
        detailLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: fileNameLabel, withOffset: 1)
        detailLabel.autoPinEdgeToSuperviewEdge(ALEdge.Trailing, withInset: 10)
        
        super.updateConstraints()
    }
}