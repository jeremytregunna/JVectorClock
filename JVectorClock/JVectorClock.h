//
//  JVectorClock.h
//  JVectorClock
//
//  Created by Jeremy Tregunna on 2013-04-06.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(char, JVectorClockComparisonResult)
{
    JOrderedAscending = -1,
    JOrderedSame = 0,
    JOrderedDescending,
    JOrderedConcurrent,
};

@interface JVectorClock : NSObject

- (JVectorClockComparisonResult)compare:(JVectorClock*)other;
- (BOOL)isConcurrent:(JVectorClock*)other;

- (void)forkClockForNodeID:(uint64_t)nodeID;
- (instancetype)mergeClock:(JVectorClock*)other;

- (id)objectForKeyedSubscript:(id)aKey;
- (NSUInteger)clockValueForNodeID:(uint64_t)nodeID;

- (NSString*)UTF8String;

@end
