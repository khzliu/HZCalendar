//
//  UIView+Calendar.h
//  FJCourt
//
//  Created by wshaolin on 14-8-28.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Calendar)

@property(nonatomic) CGPoint frameOrigin;
@property(nonatomic) CGSize frameSize;

@property(nonatomic) CGFloat frameX;
@property(nonatomic) CGFloat frameY;

@property(nonatomic) CGFloat frameRight;
@property(nonatomic) CGFloat frameBottom;

@property(nonatomic) CGFloat frameWidth;
@property(nonatomic) CGFloat frameHeight;

- (BOOL)containsSubView:(UIView *)subView;

- (BOOL)containsSubViewOfClassType:(Class)class;

@end
