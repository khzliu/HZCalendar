//
//  ZDScheduleTabelHeaderView.m
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDScheduleTabelHeaderView.h"
#import "VRGCalendarView.h"
#import "UIView+Frame.h"

#define FZDScheduleTabelHeaderViewWidth 320.0

@interface ZDScheduleTabelHeaderView() <VRGCalendarViewDelegate>

@property (nonatomic, weak) VRGCalendarView *calendarView;
@property (nonatomic, weak) UILabel *scheduleTitleLabel;
@property (nonatomic, weak) UIView *titleBottomLine;

@end

@implementation ZDScheduleTabelHeaderView

+ (instancetype)scheduleTabelHeaderView{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, FZDScheduleTabelHeaderViewWidth, 0)];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupCalendarView];
        [self setupScheduleTitleLabel];
    }
    return self;
}

- (void)setupCalendarView{
    VRGCalendarView *calendarView = [[VRGCalendarView alloc] init];
    calendarView.x = (self.frame.size.width - calendarView.bounds.size.width) * 0.5;
    calendarView.delegate = self;
    calendarView.hidden = NO;
    [self addSubview:calendarView];
    self.calendarView = calendarView;
}

- (void)setupScheduleTitleLabel{
    UILabel *scheduleTitleLabel = [[UILabel alloc] init];
    scheduleTitleLabel.backgroundColor = [UIColor clearColor];
    scheduleTitleLabel.font = [UIFont systemFontOfSize:16.0];
    scheduleTitleLabel.textAlignment = NSTextAlignmentLeft;
    scheduleTitleLabel.textColor = [UIColor lightGrayColor];
    scheduleTitleLabel.text = @"xxxxxxxxxxxxxxxxxxxxxxx";
    scheduleTitleLabel.x = 10.0;
    scheduleTitleLabel.height = 35.0;
    scheduleTitleLabel.y = self.calendarView.calendarHeight + 10.0;
    scheduleTitleLabel.width = self.frame.size.width - scheduleTitleLabel.x * 2;
    [self addSubview:scheduleTitleLabel];
    self.scheduleTitleLabel = scheduleTitleLabel;
    
    UIView *titleBottomLine = [[UIView alloc] init];
    titleBottomLine.backgroundColor = [UIColor lightGrayColor];
    titleBottomLine.x = scheduleTitleLabel.x;
    titleBottomLine.width = scheduleTitleLabel.width;
    titleBottomLine.height = 1.0;
    titleBottomLine.y = CGRectGetMaxY(scheduleTitleLabel.frame);
    [self addSubview:titleBottomLine];
    self.titleBottomLine = titleBottomLine;
    
    self.height = CGRectGetMaxY(titleBottomLine.frame);
}

- (void)setScheduleDays:(NSArray *)scheduleDays{
    _scheduleDays = scheduleDays;
    self.calendarView.scheduleDays = scheduleDays;
}

- (void)calendarView:(VRGCalendarView *)calendarView changeMonth:(NSInteger)month viewHeight:(CGFloat)viewHeight animated:(BOOL)animated{
    self.scheduleTitleLabel.y = viewHeight + 10.0;
    self.titleBottomLine.y = CGRectGetMaxY(self.scheduleTitleLabel.frame);
    if(self.delegate && [self.delegate respondsToSelector:@selector(scheduleTabelHeaderView:changeMonth:viewHeight:)]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *month = [dateFormatter stringFromDate:calendarView.currentMonth];
        [self.delegate scheduleTabelHeaderView:self changeMonth:month viewHeight:viewHeight + 45.0];
    }
}

- (void)calendarView:(VRGCalendarView *)calendarView didSelectedDate:(NSDate *)date{
    if(self.delegate && [self.delegate respondsToSelector:@selector(scheduleTabelHeaderView:didSelectedDate:)]){
        [self.delegate scheduleTabelHeaderView:self didSelectedDate:date];
    }
}

@end
