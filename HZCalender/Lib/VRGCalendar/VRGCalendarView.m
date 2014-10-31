//
//  VRGCalendarView.m
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Calendar.h"
#import "NSDate+Calendar.h"

#define CalendarViewTopBarHeight 60.0
#define CalendarViewWidth 300.0

#define CalendarViewDayWidth 43.0
#define CalendarViewDayHeight 36.0

#define CalendarViewDayDotWidth 5.0

#define CalendarViewRedColor [UIColor colorWithRed:141.0 / 255.0 green:35.0 / 255.0 blue:28.0 / 255.0 alpha:0.9]

@interface VRGCalendarView(){
    BOOL _isAnimating;
    BOOL _prepAnimationPreviousMonth;
    BOOL _prepAnimationNextMonth;
    UILabel *_currentMonthLabel;
    UIImageView *_animationView_A;
    UIImageView *_animationView_B;
}

@end

@implementation VRGCalendarView

- (void)selectDate:(NSInteger)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.currentMonth];
    [comps setDay:date];
    NSDate *newSelectedDate = [gregorian dateFromComponents:comps];
    if(self.selectedDate != nil && [self.selectedDate isEqualToDate:newSelectedDate]){
        return;
    }
    _selectedDate = newSelectedDate;
    NSInteger selectedDateYear = [self.selectedDate year];
    NSInteger selectedDateMonth = [self.selectedDate month];
    NSInteger currentMonthYear = [self.currentMonth year];
    NSInteger currentMonthMonth = [self.currentMonth month];
    
    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectedDate:)]) {
        [self.delegate calendarView:self didSelectedDate:self.selectedDate];
    }
}

- (void)setScheduleDays:(NSArray *)scheduleDays{
    _scheduleDays = scheduleDays;
    [self setNeedsDisplay];
}

- (void)reset {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    _currentMonth = [gregorian dateFromComponents:components];
    
    [self updateSize];
    [self setNeedsDisplay];
    [self changeMonthNotifyDelegate];
}

- (void)showNextMonth {
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    _prepAnimationNextMonth = YES;
    
    [self setNeedsDisplay];
    
    NSInteger lastBlock = [self.currentMonth firstWeekDayInMonth] + [self.currentMonth numDaysInMonth] - 1;
    NSInteger numBlocks = [self numRows] * 7;
    BOOL hasNextMonthDays = lastBlock < numBlocks;
    
    CGFloat oldHeight = self.calendarHeight;
    UIImage *currentMonthImage = [self drawCurrentState];
    
    _currentMonth = [self.currentMonth offsetMonth:1];
    [self changeMonthNotifyDelegate];
    _prepAnimationNextMonth = NO;
    [self setNeedsDisplay];
    
    UIImage *nextMonthImage = [self drawCurrentState];
    CGFloat newHeight = MAX(oldHeight, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, CalendarViewTopBarHeight, CalendarViewWidth, newHeight - CalendarViewTopBarHeight)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    _animationView_A = [[UIImageView alloc] initWithImage:currentMonthImage];
    _animationView_B = [[UIImageView alloc] initWithImage:nextMonthImage];
    [animationHolder addSubview:_animationView_A];
    [animationHolder addSubview:_animationView_B];
    
    if (hasNextMonthDays) {
        _animationView_B.frameY = _animationView_A.frameY + _animationView_A.frameHeight - (CalendarViewDayHeight + 3);
    } else {
        _animationView_B.frameY = _animationView_A.frameY + _animationView_A.frameHeight - 3;
    }
    
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:CalendarViewMonthChangeAnimationTimeInterval animations:^{
        [blockSafeSelf updateSize];
        if (hasNextMonthDays) {
            _animationView_A.frameY = -_animationView_A.frameHeight + CalendarViewDayHeight + 3;
        } else {
            _animationView_A.frameY = -_animationView_A.frameHeight + 3;
        }
        _animationView_B.frameY = 0;
    }                completion:^(BOOL finished) {
        [_animationView_A removeFromSuperview];
        [_animationView_B removeFromSuperview];
        _isAnimating = NO;
        [animationHolder removeFromSuperview];
    }];
}

- (void)showPreviousMonth {
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    _prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    BOOL hasPreviousDays = [_currentMonth firstWeekDayInMonth] > 1;
    CGFloat oldHeight = self.calendarHeight;
    UIImage *currentMonthImage = [self drawCurrentState];
    
    _currentMonth = [_currentMonth offsetMonth:-1];
    [self changeMonthNotifyDelegate];
    _prepAnimationPreviousMonth = NO;
    [self setNeedsDisplay];
    UIImage *previousMonthImage = [self drawCurrentState];
    
    CGFloat newHeight = fmaxf(oldHeight, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, CalendarViewTopBarHeight, CalendarViewWidth, newHeight - CalendarViewTopBarHeight)];
    
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    _animationView_A = [[UIImageView alloc] initWithImage:currentMonthImage];
    _animationView_B = [[UIImageView alloc] initWithImage:previousMonthImage];
    [animationHolder addSubview:_animationView_A];
    [animationHolder addSubview:_animationView_B];
    
    if (hasPreviousDays) {
        _animationView_B.frameY = _animationView_A.frameY - (_animationView_B.frameHeight - CalendarViewDayHeight) + 3;
    } else {
        _animationView_B.frameY = _animationView_A.frameY - _animationView_B.frameHeight + 3;
    }
    
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:CalendarViewMonthChangeAnimationTimeInterval animations:^{
        [blockSafeSelf updateSize];
        if (hasPreviousDays) {
            _animationView_A.frameY = _animationView_B.frameHeight - (CalendarViewDayHeight + 3);
        } else {
            _animationView_A.frameY = _animationView_B.frameHeight - 3;
        }
        _animationView_B.frameY = 0;
    }                completion:^(BOOL finished) {
        [_animationView_A removeFromSuperview];
        [_animationView_B removeFromSuperview];
        _isAnimating = NO;
        [animationHolder removeFromSuperview];
    }];
}

- (void)updateSize {
    self.frameHeight = self.calendarHeight;
    [self setNeedsDisplay];
}

- (CGFloat)calendarHeight {
    return CalendarViewTopBarHeight + [self numRows] * CalendarViewDayHeight;
}

- (NSInteger)numRows {
    CGFloat lastBlock = [self.currentMonth numDaysInMonth] + ([self.currentMonth firstWeekDayInMonth]);
    return ceilf(lastBlock / 7);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (touchPoint.y > CalendarViewTopBarHeight) {
        CGFloat xLocation = touchPoint.x;
        CGFloat yLocation = touchPoint.y - CalendarViewTopBarHeight;
        NSInteger column = floorf(xLocation / CalendarViewDayWidth);
        NSInteger row = floorf(yLocation / CalendarViewDayHeight);
        NSInteger blockNr = (column + 1) + row * 7;
        NSInteger firstWeekDay = [self.currentMonth firstWeekDayInMonth];
        NSInteger date = blockNr - firstWeekDay;
        [self selectDate:date];
    }else{
        CGRect rectArrowLeft = CGRectMake(60, 0, 40, 40);
        CGRect rectArrowRight = CGRectMake(self.frame.size.width - 90, 0, 40, 40);
        
        if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
            [self showPreviousMonth];
        } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
            [self showNextMonth];
        } else if (CGRectContainsPoint(_currentMonthLabel.frame, touchPoint)) {
            NSInteger currentMonthIndex = [self.currentMonth month];
            NSInteger todayMonth = [[NSDate date] month];
            [self reset];
            if(todayMonth != currentMonthIndex){
                [self changeMonthNotifyDelegate];
            }
        }
    }
}

- (void)drawRect:(CGRect)rect {
    NSInteger firstWeekDay = [self.currentMonth firstWeekDayInMonth];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年M月"];
    _currentMonthLabel.text = [dateFormatter stringFromDate:self.currentMonth];
    [_currentMonthLabel sizeToFit];
    _currentMonthLabel.frameX = (self.frame.size.width - _currentMonthLabel.frameWidth) * 0.5;
    _currentMonthLabel.frameY = 10.0;
    [self.currentMonth firstWeekDayInMonth];
    
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectangle = CGRectMake(0, 0, self.frame.size.width, CalendarViewTopBarHeight);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    CGFloat arrowSize = 15.0;
    CGFloat xmargin = 60.0;
    CGFloat ymargin = 15.0;
    
    // 左边箭头
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xmargin + arrowSize / 1.5, ymargin);
    CGContextAddLineToPoint(context, xmargin + arrowSize / 1.5, ymargin + arrowSize);
    CGContextAddLineToPoint(context, xmargin, ymargin + arrowSize * 0.5);
    CGContextAddLineToPoint(context, xmargin + arrowSize / 1.5, ymargin);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    
    // 右边箭头
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin);
    CGContextAddLineToPoint(context, self.frame.size.width - xmargin, ymargin + arrowSize * 0.5);
    CGContextAddLineToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin + arrowSize);
    CGContextAddLineToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    
    // 星期
    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];
    
    CGContextSetFillColorWithColor(context, CalendarViewRedColor.CGColor);
    for (int i = 0; i < [weekdays count]; i ++) {
        NSString *weekdayValue = (NSString *) [weekdays objectAtIndex:i];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        attributes[NSForegroundColorAttributeName] = CalendarViewRedColor;
        CGSize fontSize = [weekdayValue boundingRectWithSize:CGSizeMake(CalendarViewDayWidth, CalendarViewDayHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGFloat x = i * CalendarViewDayWidth + (CalendarViewDayWidth - fontSize.width) * 0.5;
        [weekdayValue drawWithRect:CGRectMake(x, 45, CalendarViewDayWidth, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:[attributes copy] context:nil];
    }
    CGContextFillPath(context);
    NSInteger numRows = [self numRows];
    CGContextSetAllowsAntialiasing(context, YES);
    CGFloat gridHeight = numRows * CalendarViewDayHeight;
    CGRect rectangleGrid = CGRectMake(0, CalendarViewTopBarHeight, self.frame.size.width, gridHeight);
    CGContextAddRect(context, rectangleGrid);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    NSInteger numBlocks = numRows * 7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    NSInteger currentMonthNumDays = [self.currentMonth numDaysInMonth];
    NSInteger prevMonthNumDays = [previousMonth numDaysInMonth];
    NSInteger selectedDateBlock = ([self.selectedDate day] - 1) + firstWeekDay;
    BOOL isSelectedDatePreviousMonth = _prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = _prepAnimationNextMonth;
    if (self.selectedDate != nil) {
        isSelectedDatePreviousMonth = ([self.selectedDate year] == [self.currentMonth year] && [self.selectedDate month] < [self.currentMonth month]) || [self.selectedDate year] < [self.currentMonth year];
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([self.selectedDate year] == [self.currentMonth year] && [self.selectedDate month] > [self.currentMonth month]) || [self.selectedDate year] > [self.currentMonth year];
        }
    }
    
    if (isSelectedDatePreviousMonth) {
        NSInteger lastPositionPreviousMonth = firstWeekDay - 1;
        selectedDateBlock = lastPositionPreviousMonth - ([self.selectedDate numDaysInMonth] - [self.selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [self.currentMonth numDaysInMonth] + (firstWeekDay - 1) + [self.selectedDate day];
    }
    
    NSDate *todayDate = [NSDate date];
    NSInteger todayBlock = -1;
    if ([todayDate month] == [self.currentMonth month] && [todayDate year] == [self.currentMonth year]) {
        todayBlock = [todayDate day] + firstWeekDay - 1;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont fontWithName:@"HelveticaNeue" size:18];
    for (int i = 0; i < numBlocks; i++) {
        NSInteger targetDate = i;
        NSInteger targetColumn = i % 7;
        NSInteger targetRow = i / 7;
        CGFloat targetX = targetColumn * CalendarViewDayWidth;
        CGFloat targetY = CalendarViewTopBarHeight + targetRow * CalendarViewDayHeight;
        CGRect rectangleGrid = CGRectMake(targetX + (CalendarViewDayWidth - CalendarViewDayHeight) * 0.5, targetY, CalendarViewDayHeight, CalendarViewDayHeight);
        CGContextSetFillColorWithColor(context, CalendarViewRedColor.CGColor);
        if (i < firstWeekDay) { // 上一个月
            targetDate = (prevMonthNumDays - firstWeekDay) + (i + 1);
            attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        } else if (i >= (firstWeekDay + currentMonthNumDays)) { // 下一个月
            targetDate = (i + 1) - (firstWeekDay + currentMonthNumDays);
            attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        } else {
            targetDate = (i - firstWeekDay) + 1;
            attributes[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
            
            NSString *day = [NSString stringWithFormat:@"%d-%02d-%02d", [self.currentMonth year], [self.currentMonth month], targetDate];
            // 显示红点
            if([self.scheduleDays containsObject:day]){
                CGFloat dotFrameX = rectangleGrid.origin.x + (CalendarViewDayHeight - CalendarViewDayDotWidth) * 0.5;
                CGFloat dotFrameY = CGRectGetMaxY(rectangleGrid) - CalendarViewDayDotWidth;
                CGRect dotFrame = CGRectMake(dotFrameX, dotFrameY, CalendarViewDayDotWidth, CalendarViewDayDotWidth);
                CGContextFillEllipseInRect(context, dotFrame);
                UIColor *fillColor = CalendarViewRedColor;
                CGContextSetFillColorWithColor(context, fillColor.CGColor);
                CGContextFillPath(context);
            }
        }
        
        NSString *date = [NSString stringWithFormat:@"%i", targetDate];
        
        if (self.selectedDate != nil
            && i == selectedDateBlock
            && [self.selectedDate year] == [self.currentMonth year]
            && [self.selectedDate month] == [self.currentMonth month]) {
            CGContextFillEllipseInRect(context, rectangleGrid);
            CGContextSetFillColorWithColor(context, CalendarViewRedColor.CGColor);
            CGContextFillPath(context);
            attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        } else if(todayBlock == i) {
            CGContextSetStrokeColorWithColor(context, CalendarViewRedColor.CGColor);
            CGContextStrokeEllipseInRect(context, rectangleGrid);
            CGContextStrokePath(context);
            attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
        }
        
        //  计算文字的大小
        CGSize fontSize = [date boundingRectWithSize:CGSizeMake(CalendarViewDayWidth, CalendarViewDayHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        // 绘制文字到界面
        [date drawWithRect:CGRectMake(targetX + (CalendarViewDayWidth - fontSize.width) * 0.5, targetY + (CalendarViewDayHeight - fontSize.height) * 0.5, CalendarViewDayWidth, CalendarViewDayHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    }
}

- (UIImage *)drawCurrentState {
    CGSize size = CGSizeMake(CalendarViewWidth, [self numRows] * CalendarViewDayHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, - CalendarViewTopBarHeight);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, CalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;
        _isAnimating = NO;
        _currentMonthLabel = [[UILabel alloc] init];
        _currentMonthLabel.backgroundColor = [UIColor clearColor];
        _currentMonthLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        _currentMonthLabel.textColor = CalendarViewRedColor;
        _currentMonthLabel.textAlignment = NSTextAlignmentCenter;
        _currentMonthLabel.text = @"";
        [self addSubview:_currentMonthLabel];
        
        CGFloat plusButtonW = 30.0;
        CGFloat plusButtonH = plusButtonW;
        CGFloat plusButtonX = CalendarViewWidth - plusButtonW;
        CGFloat plusButtonY = 8.0;
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        plusButton.frame = CGRectMake(plusButtonX, plusButtonY, plusButtonW, plusButtonH);
        [plusButton setImage:[UIImage imageNamed:@"office_plusbutton_normal_background"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageNamed:@"office_plusbutton_highlighted_background"] forState:UIControlStateHighlighted];
        [plusButton addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusButton];
        
        [self reset];
    }
    return self;
}

- (void)changeMonthNotifyDelegate{
    if(self.delegate && [self.delegate respondsToSelector:@selector(calendarView:changeMonth:viewHeight:animated:)]){
        [self.delegate calendarView:self changeMonth:[self.currentMonth month] viewHeight:self.calendarHeight animated:NO];
    }
}

- (void)plusButtonClick:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(calendarViewDidClickPlusButton:)]){
        [self.delegate calendarViewDidClickPlusButton:self];
    }
}

@end
