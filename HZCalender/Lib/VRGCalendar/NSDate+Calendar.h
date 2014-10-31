//
//  NSDate+Calendar.h
//  FJCourt
//
//  Created by wshaolin on 14-8-28.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)

- (NSDate *)offsetMonth:(NSInteger)numMonths;

- (NSDate *)offsetDay:(NSInteger)numDays;

- (NSDate *)offsetHours:(NSInteger)hours;

- (NSDate *)offsetMinutes:(NSInteger)minutes;

- (NSInteger)numDaysInMonth;

- (NSInteger)firstWeekDayInMonth;

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)hour;

- (NSInteger)minute;

+ (NSDate *)dateStartOfDay:(NSDate *)date;

//+ (NSDate *)dateStartOfWeek;

//+ (NSDate *)dateEndOfWeek;

// 当年的第一天，即1月1号
+ (NSDate *)firstDayOfYear;

// 根据一个日期和小时、分钟重新生成一个新的日期
- (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute;

// 当天是星期几
//- (NSString *)dayOfWeek;

@end
