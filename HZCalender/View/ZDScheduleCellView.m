//
//  ZDScheduleCellView.m
//  HZCalender
//
//  Created by Khzliu on 14-10-15.
//  Copyright (c) 2014年 khzliu. All rights reserved.
//

#import "ZDScheduleCellView.h"

@implementation ZDScheduleCellView

+ (instancetype)scheduleCellView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZDScheduleCellView class]) owner:self options:nil] firstObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setCustomModel:(ZDScheduleModel *) customModel{
    //填充模型
    if([customModel isKindOfClass:[ZDScheduleModel class]]){
        ZDScheduleModel *scheduleModel = (ZDScheduleModel *)customModel;
        [self.titleLable setText:scheduleModel.title];
        [self.dayLable setText:[self stringFormatDay:scheduleModel.time]];
        [self.timeLable setText:[self stringFormatTime:scheduleModel.time]];
        switch (scheduleModel.type) {
            case ZDScheduleDataTypeMarkerMessage:
                [self.typeLable setText:@"标讯"];
                break;
            case ZDScheduleDataTypeCircularize:
                [self.typeLable setText:@"通知"];
                break;
            default:
                break;
        }
    }
}

//设置时间
- (NSString *) stringFormatTime:(NSString *) time{
    
    //2014-08-29 13:38:00
    NSString *timeStr = time;
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSString *timeString=@"";
    
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    timeString = [NSString stringWithFormat:@"%@提醒",[dateformatter stringFromDate:d]];
    
    return timeString;
}

//设置时间
- (NSString *) stringFormatDay:(NSString *) time{
    
    //2014-08-29 13:38:00
    NSString *timeStr = time;
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:timeStr];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late - now;
    
    NSString *timeString=@"";
    
    NSInteger preDay = cha/(60*60*24);
    timeString = [NSString stringWithFormat:@"提前：%d天",preDay];
    
    return timeString;
}

@end
