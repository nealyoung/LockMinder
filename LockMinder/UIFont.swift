//
//  UIFont.swift
//  LockMinder
//
//  Created by Nealon Young on 8/10/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

extension UIFont {
    class func applicationFont(size: CGFloat) -> UIFont {
        if #available(iOS 9, *) {
            return UIFont.systemFontOfSize(size)
        } else {
            return UIFont(name: "SourceSansPro-Regular", size: size)!
        }
    }
    
    class func boldApplicationFont(size: CGFloat) -> UIFont {
        if #available(iOS 9, *) {
            return UIFont.systemFontOfSize(size, weight: UIFontWeightBold)
        } else {
            return UIFont(name: "SourceSansPro-Bold", size: size)!
        }
    }
    
    class func mediumApplicationFont(size: CGFloat) -> UIFont {
        if #available(iOS 9, *) {
            return UIFont.systemFontOfSize(size, weight: UIFontWeightMedium)
        } else {
            return UIFont(name: "SourceSansPro-Semibold", size: size)!
        }
    }
}
