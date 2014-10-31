//
//  ZDScheduleCellView.h
//  HZCalender
//
//  Created by Khzliu on 14-10-15.
//  Copyright (c) 2014年 khzliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDCustomCellContentView.h"

@interface ZDScheduleCellView : ZDCustomCellContentView

@property (nonatomic,weak) IBOutlet UILabel * titleLable;
@property (nonatomic,weak) IBOutlet UILabel * dayLable;
@property (nonatomic,weak) IBOutlet UILabel * typeLable;
@property (nonatomic,weak) IBOutlet UILabel * timeLable;

+ (instancetype)scheduleCellView;

@end
