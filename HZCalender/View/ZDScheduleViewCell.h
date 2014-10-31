//
//  ZDScheduleViewCell.h
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDContextMenuCell.h"

@class ZDScheduleModel;

@interface ZDScheduleViewCell : ZDContextMenuCell

//@property (nonatomic, strong) ZDScheduleModel *model;

@property (nonatomic, assign, getter = isLastRow) BOOL lastRow;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
