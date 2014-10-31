//
//  NSMutableArray+MoveElement.m
//  FJCourt
//
//  Created by wshaolin on 14-9-1.
//  Copyright (c) 2014年 rnd. All rights reserved.
//

#import "NSMutableArray+MoveElement.h"

@implementation NSMutableArray (MoveElement)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    if (to != from) {
        id element = [self objectAtIndex:from];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:element];
        } else {
            [self insertObject:element atIndex:to];
        }
    }
}

@end
