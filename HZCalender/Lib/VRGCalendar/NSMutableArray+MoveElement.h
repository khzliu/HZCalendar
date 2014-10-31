//
//  NSMutableArray+MoveElement.h
//  FJCourt
//
//  Created by wshaolin on 14-9-1.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MoveElement)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end
