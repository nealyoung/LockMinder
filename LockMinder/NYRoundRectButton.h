//
//  NYRoundRectButton.h
//  LockMinder
//
//  Created by Nealon Young on 7/15/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NYRoundRectButtonType) {
    NYRoundRectButtonTypeFilled,
    NYRoundRectButtonTypeBordered
};

@interface NYRoundRectButton : UIButton

@property (nonatomic) NYRoundRectButtonType type;

@property (nonatomic) CGFloat cornerRadius;

@end
