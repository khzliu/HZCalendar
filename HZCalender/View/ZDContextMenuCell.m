//
//  ZDContextMenuCell.m
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import "ZDContextMenuCell.h"
#import "ZDCustomCellContentView.h"
#import "UIView+Frame.h"

@interface ZDContextMenuCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZDCustomCellContentView *customView;
@property (nonatomic, assign) CGFloat optionItemWith;
@property (nonatomic, strong) NSArray *optionItems;

@property (nonatomic, strong) UIView *contextMenuView;
@property (nonatomic, assign) BOOL shouldDisplayContextMenuView;
@property (nonatomic, assign) CGFloat initialTouchPositionX;

@end

static UIView *view = nil;

@implementation ZDContextMenuCell

#pragma -mark 初始化

- (instancetype)initWithCustomView:(ZDCustomCellContentView *)customView contextMenuOptionsViewItems:(NSArray *)optionItems reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
   
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        self.appearPosition = ZDContextMenuOptionsViewAppearInCellPositionRight;
        
        [self removeSubviewsFormView:self.contentView];
        
        [self setupContextMenuView];
        
        _contextMenuHidden = YES;
        self.shouldDisplayContextMenuView = NO;
        self.enableEdit = YES;
        self.menuOptionsAnimationDuration = 0.3;
        self.bounce = 30.0;
        self.optionItemWith = 70.0;
        
        self.customView = customView;
        self.optionItems = optionItems;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)setupContextMenuView{
    self.contextMenuView = [[UIView alloc] init];
    self.contextMenuView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.contextMenuView.hidden = YES;
    [self.contentView addSubview:self.contextMenuView];
}

- (void)removeSubviewsFormView:(UIView *)view{
    for(UIView *subview in view.subviews){
        [subview removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (self.contextMenuHidden) {
        self.contextMenuView.hidden = YES;
        [super setSelected:selected animated:animated];
    }
}

#pragma -mark setter

- (void)setCustomModel:(id)customModel{
    _customModel = customModel;
    self.customView.customModel = customModel;
}

- (void)setEnableEdit:(BOOL)enableEdit{
    if(_enableEdit != enableEdit){
        _enableEdit = enableEdit;
        [self setNeedsLayout];
    }
}

- (void)setCustomView:(ZDCustomCellContentView *)customView{
    _customView = customView;
    [self.contentView addSubview:customView];
    [self setNeedsLayout];
}

- (void)setOptionItems:(NSArray *)optionItems{
    _optionItems = optionItems;
    if(optionItems.count > 6){
        self.optionItemWith = 280.0 / optionItems.count;
    }
    [self removeSubviewsFormView:self.contextMenuView];
    for(int i = 0; i < optionItems.count; i ++){
        UIButton *item = optionItems[i];
        item.tag = i;
        [item addTarget:self action:@selector(optionItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contextMenuView addSubview:item];
    }
    [self setNeedsLayout];
}

- (void)setContextMenuViewBackgroudColor:(UIColor *)contextMenuViewBackgroudColor{
    _contextMenuViewBackgroudColor = contextMenuViewBackgroudColor;
    self.contextMenuView.backgroundColor = contextMenuViewBackgroudColor;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
        CGFloat currentTouchPositionX = currentTouchPoint.x;
        CGPoint velocity = [recognizer velocityInView:self.contentView];
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:{
                self.initialTouchPositionX = currentTouchPositionX;
                if (velocity.x > 0) {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(contextMenuOptionsViewWillDisappearInCell:)]){
                        [self.delegate contextMenuOptionsViewWillDisappearInCell:self];
                    }
                } else {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(contextMenuOptionsViewWillAppearInCell:)]){
                        [self.delegate contextMenuOptionsViewWillAppearInCell:self];
                    }
                }
                break;
            }
            case UIGestureRecognizerStateChanged:{
                CGPoint velocity = [recognizer velocityInView:self.contentView];
                BOOL shouldShowMenuOptionsViewAtIndexPath = YES;
                if(self.delegate && [self.delegate respondsToSelector:@selector(contextMenuCell:shouldShowMenuOptionsViewAtIndexPath:)]){
                    shouldShowMenuOptionsViewAtIndexPath = [self.delegate contextMenuCell:self shouldShowMenuOptionsViewAtIndexPath:self.indexPath];
                }
                if (!self.contextMenuHidden || (velocity.x > 0. || shouldShowMenuOptionsViewAtIndexPath)) {
                    if (self.selected) {
                        [self setSelected:NO animated:NO];
                    }
                    self.contextMenuView.hidden = NO;
                    CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;
                    self.initialTouchPositionX = currentTouchPositionX;
                    CGFloat minOriginX = -[self contextMenuWidth] - self.bounce;
                    CGFloat maxOriginX = 0;
                    CGFloat originX = CGRectGetMinX(self.customView.frame) + panAmount;
                    originX = MIN(maxOriginX, originX);
                    originX = MAX(minOriginX, originX);
                    
                    if ((originX < -0.5 * [self contextMenuWidth] && velocity.x < 0) || velocity.x < -self.optionItemWith) {
                        self.shouldDisplayContextMenuView = YES;
                    } else if ((originX > -0.3 * [self contextMenuWidth] && velocity.x > 0) || velocity.x > self.optionItemWith) {
                        self.shouldDisplayContextMenuView = NO;
                    }
                    self.customView.x = originX;
                }
                break;
            }
            case UIGestureRecognizerStateEnded:{
                [self setMenuOptionsViewHidden:!self.shouldDisplayContextMenuView animated:YES completion:nil];
                break;
            }
            case UIGestureRecognizerStateCancelled:{
                [self setMenuOptionsViewHidden:!self.shouldDisplayContextMenuView animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
    }
}

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion{
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGFloat contextMenuContentViewX = -[self contextMenuWidth];
    if(hidden){
        contextMenuContentViewX = 0;
    }
    [UIView animateWithDuration:self.menuOptionsAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.customView.x = contextMenuContentViewX;
    } completion:^(BOOL finished) {
        _contextMenuHidden = hidden;
        self.shouldDisplayContextMenuView = !hidden;
        if (hidden) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(contextMenuOptionsViewDidDisappearInCell:)]){
                [self.delegate contextMenuOptionsViewDidDisappearInCell:self];
            }
        } else {
            if(self.delegate && [self.delegate respondsToSelector:@selector(contextMenuOptionsViewDidAppearInCell:)]){
                [self.delegate contextMenuOptionsViewDidAppearInCell:self];
            }
        }
        if (completion) {
            completion();
        }
    }];
}

- (CGFloat)contextMenuWidth{
    return self.optionItems.count * self.optionItemWith;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.customView.frame = self.bounds;
    self.contextMenuView.frame = self.bounds;
    [self.contentView sendSubviewToBack:self.contextMenuView];
    [self.contentView bringSubviewToFront:self.customView];
    
    CGFloat itemX = 0;
    for(int i = 0; i < self.contextMenuView.subviews.count; i ++){
        UIButton *item = self.contextMenuView.subviews[i];
        itemX = self.width - self.optionItemWith * (self.contextMenuView.subviews.count - i);
        item.frame = CGRectMake(itemX, 0, self.optionItemWith, self.bounds.size.height);
    }
}

- (void)optionItemClick:(UIButton *)item{
    if(self.delegate && [self.delegate respondsToSelector:@selector(contextMenuCell:optionsViewAtIndexPath:didClickOptionsViewItemAtIndex:)]){
        [self.delegate contextMenuCell:self optionsViewAtIndexPath:self.indexPath didClickOptionsViewItemAtIndex:item.tag];
    }
}

#pragma -mark 手势代理方法

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

@end
