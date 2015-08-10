//
//  ImageGenerator.swift
//  LockMinder
//
//  Created by Nealon Young on 8/9/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

import Foundation
import EventKit

class ImageGenerator {
    class func generateImage(backgroundImage: UIImage, reminders: [EKReminder]) -> UIImage {
        let ClockHeight: CGFloat = 160.0
        let SliderHeight: CGFloat = 90.0
        let ListBackgroundInset: CGFloat = 20.0
        let ListItemXInset: CGFloat = 15.0
        let ListItemPadding: CGFloat = 2.0
        let ItemBulletWidth: CGFloat = 5.0
        
        let screenBounds = UIScreen.mainScreen().bounds
        let scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(screenBounds.size, true, scale)
        let ctx = UIGraphicsGetCurrentContext()
        
        let horizontalImageScale = screenBounds.size.width / backgroundImage.size.width
        let verticalImageScale = screenBounds.size.height / backgroundImage.size.height
        
        var imageRect: CGRect

        if (horizontalImageScale > verticalImageScale) {
            imageRect = CGRectMake(0.0, 0.0, backgroundImage.size.width * horizontalImageScale, backgroundImage.size.height * horizontalImageScale);
        } else {
            imageRect = CGRectMake(0.0, 0.0, backgroundImage.size.width * verticalImageScale, backgroundImage.size.height * verticalImageScale);
        }
        
        self.drawGradientBackground(
            ctx,
            startColor: UIColor(red: 0.33, green: 0.26, blue: 0.43, alpha: 1.0),
            endColor:   UIColor(red: 0.24, green: 0.16, blue: 0.36, alpha: 1.0)
        )
        
        var listBackgroundHeight = ListItemXInset * 2.0
        
        let reminderFont = UIFont(name: "HelveticaNeue-Light", size: 17.0)!
        
        for reminder in reminders {
            var reminderRect = reminder.title.boundingRectWithSize(
                CGSizeMake(screenBounds.size.width - (ListBackgroundInset * 2.0) - (ListItemXInset * 2.0), 9999.0),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: reminderFont],
                context: nil
            )
            
            reminderRect.size.height += ListItemPadding * 2.0;
            listBackgroundHeight += reminderRect.height
        }
        
        let maxListHeight = screenBounds.size.height - ClockHeight - SliderHeight
        if (listBackgroundHeight > maxListHeight) {
            listBackgroundHeight = maxListHeight;
        }
        
        
        // If the list is smaller than the space between the clock and unlock slider, center it vertically
        let listVerticalOffset = (maxListHeight - listBackgroundHeight) / 2.0;
        
        // Determine the size of the overlay
        let listBackgroundRect = CGRect(
            x: ListBackgroundInset,
            y: ClockHeight + listVerticalOffset,
            width: screenBounds.size.width - ListBackgroundInset * 2.0,
            height: listBackgroundHeight
        );
        
        let listBackgroundPath = UIBezierPath(
            roundedRect: listBackgroundRect,
            byRoundingCorners: .AllCorners,
            cornerRadii: CGSize(width: 10.0, height: 10.0)
        )
        
        CGContextAddPath(ctx, listBackgroundPath.CGPath);
        CGContextSetFillColorWithColor(ctx, UIColor(white: 1.0, alpha: 0.8).CGColor);
        CGContextFillPath(ctx);
        
        var yOffset: CGFloat = 0.0
        
        for (index, reminder) in enumerate(reminders) {
            println("Item \(index): \(reminder)")
            
            // Draw the bullet point
            let itemBulletRect = CGRect(
                x: CGRectGetMinX(listBackgroundRect) + ListItemXInset,
                y: CGRectGetMinY(listBackgroundRect) + ListItemXInset + yOffset + ItemBulletWidth * 1.5,
                width: ItemBulletWidth,
                height: ItemBulletWidth
            );
            
            let itemBulletPath = UIBezierPath(ovalInRect: itemBulletRect)
            
            CGContextBeginPath(ctx);
            CGContextAddPath(ctx, itemBulletPath.CGPath);
            CGContextSetFillColorWithColor(ctx, UIColor.blackColor().CGColor);
            CGContextFillPath(ctx);
            
            // Compute the size required to display the reminder (to support multi-line text)
            var reminderRect = reminder.title.boundingRectWithSize(
                CGSizeMake(screenBounds.size.width - (ListBackgroundInset * 2.0) - (ListItemXInset * 2.0), 9999.0),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: reminderFont],
                context: nil
            )

            reminderRect.origin = CGPointMake(CGRectGetMinX(listBackgroundRect) + ListItemXInset + (ItemBulletWidth * 2.0),
            CGRectGetMinY(listBackgroundRect) + ListItemXInset + yOffset);
            reminderRect.size.height += ListItemPadding * 2.0;
            
            
            yOffset += CGRectGetHeight(reminderRect);
            
            reminder.title.drawInRect(
                reminderRect,
                withAttributes: [NSFontAttributeName: reminderFont]
            )
        }
        
        let img = CGBitmapContextCreateImage(ctx);
        UIGraphicsEndImageContext();
        
        let wallpaperImage = UIImage(CGImage: img)!;
        return wallpaperImage;
    }
    
    private class func drawGradientBackground(context: CGContextRef, startColor: UIColor, endColor: UIColor) {
        let colors = [startColor.CGColor, endColor.CGColor];
        
        let colorspace = CGColorSpaceCreateDeviceRGB();
        
        let gradient = CGGradientCreateWithColors(colorspace, colors, nil);
        
        let screenBounds = UIScreen.mainScreen().bounds;
        
        let startPoint = CGPointMake(0.0, 0.0)
        let endPoint = CGPointMake(0.0, CGRectGetMaxY(screenBounds))
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    }
}