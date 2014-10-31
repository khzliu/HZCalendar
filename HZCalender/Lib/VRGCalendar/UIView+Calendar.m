//
//  UIView+Calendar.m
//  FJCourt
//
//  Created by wshaolin on 14-8-28.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import "UIView+Calendar.h"

@implementation UIView (Calendar)

- (BOOL)containsSubView:(UIView *)subView {
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsSubViewOfClassType:(Class)class {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:class]) {
            return YES;
        }
    }
    return NO;
}

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin {
    CGRect frame = self.frame;
    frame.origin.x = frameOrigin.x;
    frame.origin.y = frameOrigin.y;
    self.frame = frame;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize {
    CGRect frame = self.frame;
    frame.size.width = frameSize.width;
    frame.size.height = frameSize.height;
    self.frame = frame;
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)frameX {
    CGRect frame = self.frame;
    frame.origin.x = frameX;
    self.frame = frame;
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)frameY {
    CGRect frame = self.frame;
    frame.origin.y = frameY;
    self.frame = frame;
}

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)frameRight {
    CGRect frame = self.frame;
    frame.origin.x = frameRight - self.frameWidth;
    self.frame = frame;
}

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)frameBottom {
    CGRect frame = self.frame;
    frame.origin.y = frameBottom - self.frameHeight;
    self.frame = frame;
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth {
    CGRect frame = self.frame;
    frame.size.width = frameWidth;
    self.frame = frame;
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight {
    CGRect frame = self.frame;
    frame.size.height = frameHeight;
    self.frame = frame;
}

@end
