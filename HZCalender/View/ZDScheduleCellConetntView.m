//
//  ZDScheduleCellConetntView.m
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDScheduleCellConetntView.h"
#import "ZDScheduleModel.h"

#define ZDScheduleCellConetntViewWidth 320.0
#define ZDScheduleCellConetntViewHeight 70.0

@interface ZDScheduleCellConetntView()


@end

@implementation ZDScheduleCellConetntView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
//        UILabel *nameLabel = [[UILabel alloc] init];
//        nameLabel.textColor = [UIColor darkGrayColor];
//        nameLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:nameLabel];
//        self.nameLabel = nameLabel;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = ZDScheduleCellConetntViewWidth;
    frame.size.height = ZDScheduleCellConetntViewHeight;
    [super setFrame:frame];
}

@end
