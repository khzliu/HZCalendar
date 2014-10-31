//
//  ZDScheduleModel.h
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <Foundation/Foundation.h>

//提醒消息数据类型
typedef NS_ENUM(NSInteger, ZDScheduleDataType) {
    ZDScheduleDataTypeMarkerMessage = 0,    //标讯
    ZDScheduleDataTypeCircularize   = 1,    //通知政策
};

@interface ZDScheduleModel : NSObject

@property (nonatomic ,assign) NSInteger index;
@property (nonatomic, assign) ZDScheduleDataType type;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * urls;

- (instancetype)initWithIndex:(NSInteger )nIndex type:(ZDScheduleDataType)nType title:(NSString *)nTitle url:(NSString *)nUrl time:(NSString *) nTime; 
@end
