//
//  UIBorderedLabel.swift
//  standToMake
//
//  Created by Karl Oscar Weber on 9/13/14.
//  Copyright (c) 2014 Karl Oscar Weber. All rights reserved.
//
//  Thanks to: http://userflex.wordpress.com/2012/04/05/uilabel-custom-insets/

import UIKit

class UIBorderedLabel: UILabel {
    
    var topInset:       CGFloat = 2
    var rightInset:     CGFloat = 2
    var bottomInset:    CGFloat = 2
    var leftInset:      CGFloat = 2
    
//    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//        let cgrect: CGRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height + 15)
//        super.frame = cgrect
//        return super.textRectForBounds(cgrect, limitedToNumberOfLines: numberOfLines)
//    }
    
    override func sizeToFit() {
        super.sizeToFit()
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 10)
    }
    
//    override func drawTextInRect(rect: CGRect) {
//        let cgrect: CGRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width + 5, bounds.size.height + 5)
//        var insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
//        self.setNeedsLayout()
//        return super.drawTextInRect(UIEdgeInsetsInsetRect(cgrect, insets))
//    }
//    
//    
//    override func sizeThatFits(size: CGSize) -> CGSize {
//        let newSize: CGSize = super.sizeThatFits(size)
//        return CGSizeMake(newSize.width, newSize.height + 10)
//    }
}