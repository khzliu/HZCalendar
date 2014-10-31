//
//  ZDOverlayView.m
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDOverlayView.h"

@implementation ZDOverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [self.delegate overlayView:self didHitTest:point withEvent:event];
}

@end
