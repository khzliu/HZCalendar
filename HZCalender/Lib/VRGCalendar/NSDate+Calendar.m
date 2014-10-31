//
//  NSDate+Calendar.m
//  FJCourt
//
//  Created by wshaolin on 14-8-28.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import "NSDate+Calendar.h"
#import "NSMutableArray+MoveElement.h"

@implementation NSDate (Calendar)

- (NSInteger)year {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSYearCalendarUnit fromDate:self] year];
}

- (NSInteger)month {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSMonthCalendarUnit fromDate:self] month];
}

- (NSInteger)day {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSDayCalendarUnit fromDate:self] day];
}

- (NSInteger)hour {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSHourCalendarUnit fromDate:self] hour];
}

- (NSInteger)minute {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorian components:NSMinuteCalendarUnit fromDate:self] minute];
}

- (NSInteger)firstWeekDayInMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    return [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:newDate];
}

- (NSDate *)offsetMonth:(NSInteger)numMonths {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)offsetHours:(NSInteger)hours {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:hours];
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)offsetMinutes:(NSInteger)minutes{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMinute:minutes];
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)offsetDay:(NSInteger)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSInteger)numDaysInMonth {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    return range.length;
}

+ (NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return [gregorian dateFromComponents:components];
}

+ (NSDate *)firstDayOfYear{
    unsigned units  = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *comp = [calendar components:units fromDate:[NSDate date]];
    [comp setMonth:1];
    [comp setDay:1];
    return [calendar dateFromComponents:comp];
}

- (NSDate *)dateWithHour:(NSInteger)hour minute:(NSInteger)minute{
    unsigned units  = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:units fromDate:self];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    return [calendar dateFromComponents:dateComponents];
}
@end
