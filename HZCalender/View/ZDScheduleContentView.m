//
//  ZDScheduleContentView.m
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDScheduleContentView.h"
#import "ZDScheduleTabelHeaderView.h"
#import "UIView+Frame.h"
#import "ZDScheduleViewCell.h"
#import "ZDScheduleModel.h"

#define FJScheduleViewCellHeight 70.0

@interface ZDScheduleContentView() <UITableViewDataSource, UITableViewDelegate, ZDScheduleTabelHeaderViewDeletage>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *scheduleDatas;
@property (nonatomic, strong) ZDScheduleTabelHeaderView *scheduleTabelHeaderView;
@property (nonatomic, assign) CGFloat scheduleTabelHeaderViewHeight;

@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;

@property (strong, nonatomic) NSMutableArray *scheduleDays;
@property (strong, nonatomic) NSDate *currentSelectedDate;

@end

@implementation ZDScheduleContentView

#pragma -mark 初始化

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 25, 0);
        [self addSubview:tableView];
        self.tableView = tableView;
        
        self.scheduleTabelHeaderView = [ZDScheduleTabelHeaderView scheduleTabelHeaderView];
        self.scheduleTabelHeaderView.delegate = self;
        self.scheduleTabelHeaderViewHeight = self.scheduleTabelHeaderView.height;
        
        self.customEditing = NO;
        self.customEditingAnimationInProgress = NO;
        
        self.currentSelectedDate = [NSDate date];
    }
    return self;
}

#pragma -mark getter setter

- (NSMutableArray *)scheduleDatas{
    if(_scheduleDatas == nil){
        _scheduleDatas = [NSMutableArray array];
    }
    return _scheduleDatas;
}

- (NSMutableArray *)scheduleDays{
    if(_scheduleDays == nil){
        _scheduleDays = [NSMutableArray array];
    }
    return _scheduleDays;
}

#pragma -mark tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.scheduleDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDScheduleViewCell * cell = [ZDScheduleViewCell cellWithTableView:tableView];
    cell.customModel = self.scheduleDatas[indexPath.row];
    cell.lastRow = indexPath.row == self.scheduleDatas.count - 1;
    return cell;
}

#pragma -mark tableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FJScheduleViewCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.scheduleTabelHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.scheduleTabelHeaderViewHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark scheduleHeaderView代理方法
//改变月份处理
- (void)scheduleTabelHeaderView:(ZDScheduleTabelHeaderView *)scheduleTabelHeaderView changeMonth:(NSString *)month viewHeight:(CGFloat)height{
    self.scheduleTabelHeaderViewHeight = height;
}

//选中某天代理
- (void)scheduleTabelHeaderView:(ZDScheduleTabelHeaderView *)scheduleTabelHeaderView didSelectedDate:(NSDate *)date{
    self.currentSelectedDate = date;
}

#pragma -mark 发送网络请求

- (void)loadTodayScheduleData{
    ZDScheduleModel * tData = [[ZDScheduleModel alloc] initWithIndex:0 type:ZDScheduleDataTypeMarkerMessage title:@"北京福田项目招标实施细则第23号文件（中央规划局办公厅）" url:@"www.baidu.com" time:@"2014-10-20 08:30:00"];
    self.scheduleDatas = [NSMutableArray arrayWithObjects:tData,tData,tData,tData, nil];
}

@end
