//
//  ZDScheduleTabelHeaderView.h
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZDScheduleTabelHeaderView;

@protocol ZDScheduleTabelHeaderViewDeletage <NSObject>

@optional

- (void)scheduleTabelHeaderView:(ZDScheduleTabelHeaderView *)scheduleTabelHeaderView didSelectedDate:(NSDate *)date;

- (void)scheduleTabelHeaderView:(ZDScheduleTabelHeaderView *)scheduleTabelHeaderView changeMonth:(NSString *)month viewHeight:(CGFloat)height;

@end

@interface ZDScheduleTabelHeaderView : UIView

@property (nonatomic, weak) id<ZDScheduleTabelHeaderViewDeletage> delegate;

@property (nonatomic, strong) NSArray *scheduleDays; // 显示红点的数据

+ (instancetype)scheduleTabelHeaderView;

@end
