//
//  ZDScheduleViewCell.m
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDScheduleViewCell.h"
#import "ZDScheduleCellView.h"


@implementation ZDScheduleViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseIdentifier = @"ZDScheduleViewCell";
    ZDScheduleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setTitle:@"修改" forState:UIControlStateNormal];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        
        ZDScheduleCellView *customView = [ZDScheduleCellView scheduleCellView];
        cell = [[self alloc] initWithCustomView:customView contextMenuOptionsViewItems:@[editButton, deleteButton] reuseIdentifier:reuseIdentifier];
    }
    return cell;
}




@end
