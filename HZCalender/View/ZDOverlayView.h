//
//  ZDOverlayView.h
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZDOverlayView;

@protocol ZDOverlayViewDelegate <NSObject>

@required

- (UIView *)overlayView:(ZDOverlayView *)overlayView didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end

@interface ZDOverlayView : UIView

@property (nonatomic, weak) id<ZDOverlayViewDelegate> delegate;

@end
