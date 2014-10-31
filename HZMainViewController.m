//
//  HZMainViewController.m
//  HZCalender
//
//  Created by Khzliu on 14-10-14.
//  Copyright (c) 2014年 khzliu. All rights reserved.
//

#import "HZMainViewController.h"
#import "ZDScheduleContentView.h"

@interface HZMainViewController ()

@end

@implementation HZMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ZDScheduleContentView * calenderView = [[ZDScheduleContentView alloc] initWithFrame:self.view.frame];
    [calenderView loadTodayScheduleData];
    [self.view addSubview:calenderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
