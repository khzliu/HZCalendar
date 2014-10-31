//
//  ZDScheduleModel.m
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDScheduleModel.h"

@implementation ZDScheduleModel

- (instancetype) initWithIndex:(NSInteger )nIndex type:(ZDScheduleDataType) nType title:(NSString *)nTitle url:(NSString *)nUrl time:(NSString *) nTime{
    if (self = [super init]) {
        self.index = nIndex;
        self.type = nType;
        self.time = nTime;
        self.title = nTitle;
        self.urls = nUrl;
    }
    return self;
}

@end
