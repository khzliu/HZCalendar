//
//  VRGCalendarView.h
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>

// 月份切换动画执行时间（单位：秒）
#define CalendarViewMonthChangeAnimationTimeInterval 0.25

@class VRGCalendarView;

@protocol VRGCalendarViewDelegate <NSObject>

@optional

- (void)calendarView:(VRGCalendarView *)calendarView didSelectedDate:(NSDate *)date;

- (void)calendarViewDidClickPlusButton:(VRGCalendarView *)calendarView;

- (void)calendarView:(VRGCalendarView *)calendarView changeMonth:(NSInteger)month viewHeight:(CGFloat)viewHeight animated:(BOOL)animated;

@end

@interface VRGCalendarView : UIView

@property (nonatomic, weak) id <VRGCalendarViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSDate *currentMonth;
@property (nonatomic, assign, readonly) CGFloat calendarHeight;
@property (nonatomic, strong, readonly) NSDate *selectedDate;
@property (nonatomic, strong) NSArray *scheduleDays;

@end
