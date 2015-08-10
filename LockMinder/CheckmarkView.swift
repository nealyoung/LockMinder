//
//  CheckmarkView.swift
//  LockMinder
//
//  Created by Nealon Young on 8/7/15.
//  Copyright © 2015 Nealon Young. All rights reserved.
//

import UIKit

class CheckmarkView: UIView {
    let Inset = 4.0
    
    var selected: Bool
    
    override init(frame: CGRect) {
        self.selected = false
        
        super.init(frame: frame)
        
        self.opaque = false
        self.clipsToBounds = false
    }
    
    required init(coder aDecoder: NSCoder) {
        self.selected = false
        
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        let borderPath = UIBezierPath(ovalInRect: CGRectInset(rect, CGFloat(Inset), CGFloat(Inset)))
        
        CGContextAddPath(ctx, borderPath.CGPath);
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor);
        CGContextSetShadowWithColor(ctx, CGSizeZero, 5.0, UIColor.grayColor().CGColor);
        CGContextStrokePath(ctx);
        
        CGContextSetShadowWithColor(ctx, CGSizeZero, 5.0, nil);

        
        if (self.selected) {
            CGContextBeginPath(ctx);
            
            let circleRect = CGRectInset(rect, CGFloat(Inset + 1.0), CGFloat(Inset + 1.0));
            let circlePath = UIBezierPath(ovalInRect: circleRect)
            CGContextAddPath(ctx, circlePath.CGPath);
            CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
            CGContextFillPath(ctx);
            
            // Draw the checkmark
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(   ctx, CGRectGetWidth(rect) * 0.24, CGRectGetHeight(rect) * 0.5);
            CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) * 0.41, CGRectGetHeight(rect) * 0.66);
            CGContextAddLineToPoint(ctx, CGRectGetWidth(rect) * 0.72, CGRectGetHeight(rect) * 0.34);
            CGContextSetLineWidth(ctx, 2.0);
            CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor);
            CGContextStrokePath(ctx);
        } else {
            
        }
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        self.selected = selected
        self.setNeedsDisplay()
        
        let scale: CGFloat = selected ? 1.1 : 0.9
        
        UIView.animateWithDuration(
            0.16,
            animations: { () -> Void in
                self.transform = CGAffineTransformMakeScale(scale, scale)
            }, completion: { (completed: Bool) -> Void in
                UIView.animateWithDuration(
                    0.16,
                    animations: { () -> Void in
                        self.transform = CGAffineTransformIdentity
                    },
                    completion: nil
                )
            }
        )
        
//        UIView.animateWithDuration(
//            2.0,
//            delay: 0.0,
//            usingSpringWithDamping: 0.2,
//            initialSpringVelocity: 0.0,
//            options: .Autoreverse,
//            animations: { () -> Void in
//                self.transform = CGAffineTransformMakeScale(scale, scale)
//            },
//            completion: { (completed: Bool) -> Void in
//                self.transform = CGAffineTransformIdentity
//            }
//        )
        
//        UIView.animateWithDuration(
//            2.0,
//            delay: 0.0,
//            usingSpringWithDamping: 0.2,
//            initialSpringVelocity: 0.0,
//            options: nil,
//            animations: { () -> Void in
//                self.transform = CGAffineTransformMakeScale(scale, scale)
//            },
//            completion: { (completed: Bool) -> Void in
//                UIView.animateWithDuration(
//                    0.5,
//                    delay: 0.0,
//                    usingSpringWithDamping: 0.2,
//                    initialSpringVelocity: 0.0,
//                    options: nil,
//                    animations: { () -> Void in
//                        self.transform = CGAffineTransformIdentity
//                    },
//                    completion: nil
//                )
//            }
//        )
    }
}