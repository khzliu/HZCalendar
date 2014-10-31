//
//  ZDContextMenuCell.h
//  ZDCalendar
//
//  Created by wshaolin on 14-10-8.
//  Copyright (c) 2014年 wshaolin. All rights reserved.
//

#import <UIKit/UIKit.h>
// 快捷菜单出现在cell中的位置
typedef NS_ENUM(NSInteger,ZDContextMenuOptionsViewAppearInCellPosition){
    ZDContextMenuOptionsViewAppearInCellPositionLeft,   // 出现在cell的左边
    ZDContextMenuOptionsViewAppearInCellPositionRight   // 出现在cell的右边，默认
};

@class ZDContextMenuCell, ZDCustomCellContentView;

@protocol ZDContextMenuCellDelegate <NSObject>

@optional

// 是否需要显示快捷菜单，默认返回YES
- (BOOL)contextMenuCell:(ZDContextMenuCell *)cell shouldShowMenuOptionsViewAtIndexPath:(NSIndexPath *)indexPath;

// 快捷菜单即将出现
- (void)contextMenuOptionsViewWillAppearInCell:(ZDContextMenuCell *)cell;
// 快捷菜单已经出现
- (void)contextMenuOptionsViewDidAppearInCell:(ZDContextMenuCell *)cell;

// 快捷菜单即将消失
- (void)contextMenuOptionsViewWillDisappearInCell:(ZDContextMenuCell *)cell;
// 快捷菜单已经消失
- (void)contextMenuOptionsViewDidDisappearInCell:(ZDContextMenuCell *)cell;

- (void)contextMenuCell:(ZDContextMenuCell *)cell optionsViewAtIndexPath:(NSIndexPath *)indexPath didClickOptionsViewItemAtIndex:(NSInteger)itemIndex;

@end

@interface ZDContextMenuCell : UITableViewCell

@property (nonatomic, weak) id<ZDContextMenuCellDelegate> delegate;
@property (nonatomic, strong) id customModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign, getter = isEnableEdit) BOOL enableEdit;
@property (nonatomic, assign) CGFloat menuOptionsAnimationDuration;
@property (nonatomic, assign) CGFloat bounce;
@property (nonatomic, assign, readonly, getter = isContextMenuHidden) BOOL contextMenuHidden;

@property (nonatomic, strong) UIColor *contextMenuViewBackgroudColor;
@property (nonatomic, assign) ZDContextMenuOptionsViewAppearInCellPosition appearPosition; // 暂不支持
@property (nonatomic, assign, readonly) CGFloat contextMenuWidth;

/**
 *  初始化cell
 *
 *  @param customView       自定义的cell的内容View
 *  @param optionItems      contextMenu上的按钮数组
 *  @param reuseIdentifier  cell的重用标识符
 *
 */
- (instancetype)initWithCustomView:(ZDCustomCellContentView *)customView contextMenuOptionsViewItems:(NSArray *)optionItems reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

- (CGFloat)contextMenuWidth;

@end