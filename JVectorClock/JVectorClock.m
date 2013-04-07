//
//  JVectorClock.m
//  JGossip
//
//  Created by Jeremy Tregunna on 2013-04-06.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JVectorClock.h"

static NSComparisonResult JVectorClockComparisonSort(NSNumber* aNumber, NSNumber* bNumber, void* context)
{
    JVectorClockComparisonResult aResult = (JVectorClockComparisonResult)[aNumber charValue];
    JVectorClockComparisonResult bResult = (JVectorClockComparisonResult)[bNumber charValue];

    if(aResult == JOrderedConcurrent && bResult == JOrderedConcurrent)
        return NSOrderedSame;
    else if(aResult < bResult)
        return NSOrderedAscending;
    else if(aResult > bResult)
        return NSOrderedDescending;
    return NSOrderedSame;
}

@interface JVectorClock ()
@property (nonatomic, strong) NSMutableDictionary* clockOptions;
@property (nonatomic, strong) NSArray* orderedNodeIDs;
@property (nonatomic, strong) NSArray* orderedValues;
@end

@implementation JVectorClock

- (id)init
{
    if((self = [super init]))
        _clockOptions = [NSMutableDictionary dictionary];
    return self;
}

#pragma mark - Comparison

- (JVectorClockComparisonResult)compare:(JVectorClock*)other
{
    __block BOOL equal = YES;
    __block BOOL greater = YES;
    __block BOOL smaller = YES;

    NSArray* otherKeys = [other.clockOptions allKeys];
    [_clockOptions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if([otherKeys indexOfObject:key] != NSNotFound)
        {
            if([obj isEqualToNumber:other.clockOptions[key]] == NSOrderedDescending)
            {
                equal = NO;
                greater = NO;
            }
            if([obj isEqualToNumber:other.clockOptions[key]] == NSOrderedAscending)
            {
                equal = NO;
                smaller = NO;
            }
        }
        else if([obj isEqualToNumber:@0] == NO)
        {
            equal = NO;
            smaller = NO;
        }
    }];

    [other.clockOptions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if([[_clockOptions allKeys] indexOfObject:key] != NSNotFound && [obj isEqualToNumber:@0] == NO)
        {
            equal = NO;
            greater = NO;
        }
    }];

    if(equal)
        return JOrderedSame;
    else if(greater && !smaller)
        return JOrderedAscending;
    else if(smaller && !greater)
        return JOrderedDescending;
    else
        return JOrderedConcurrent;
}

- (BOOL)isConcurrent:(JVectorClock*)other
{
    return [self compare:other] == JOrderedConcurrent;
}

#pragma mark - Vector clock operations

- (void)forkClockForNodeID:(uint32_t)nodeID
{
    @synchronized(self)
    {
        NSNumber* clock = _clockOptions[@(nodeID)];
        _clockOptions[@(nodeID)] = clock ? @([clock unsignedIntegerValue] + 1) : @1;
    }
}

- (instancetype)mergeClock:(JVectorClock*)other
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    __weak NSMutableDictionary* clockOptions = clock.clockOptions;

    [[_clockOptions allKeys] enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL* stop) {
        clockOptions[obj] = _clockOptions[obj];
    }];

    [[other.clockOptions allKeys] enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL* stop) {
        if(clockOptions[obj] == nil || [clockOptions[obj] unsignedIntValue] < [other[obj] unsignedIntValue])
        {
            clockOptions[obj] = other[obj];
        }
    }];

    return clock;
}

#pragma mark - Subscripting

- (id)objectForKeyedSubscript:(id)aKey
{
    NSNumber* num = _clockOptions[aKey];
    if(num == nil)
        num = @0;
    return num;
}

#pragma mark - Pretty printing

- (NSString*)UTF8String
{
    NSArray* orderedIds = self.orderedNodeIDs;
    NSArray* orderedValues = self.orderedValues;
    NSMutableString* text = [@"(" mutableCopy];

    for(NSUInteger i = 0; i < [orderedIds count]; i++)
    {
        [text appendFormat:@"%@ = %@", orderedIds[i], orderedValues[i]];
        if(i + 1 < [orderedIds count])
           [text appendString:@", "];
    }

    [text appendString:@")"];

    return [text copy];
}

#pragma mark - Accessors

- (NSArray*)orderedNodeIDs
{
    return [[_clockOptions allKeys] sortedArrayUsingFunction:JVectorClockComparisonSort context:NULL];
}

- (NSArray*)orderedValues
{
    NSArray* orderedIDs = [self orderedNodeIDs];
    __block NSMutableArray* orderedValues = [NSMutableArray arrayWithCapacity:[orderedIDs count]];

    [orderedIDs enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL* stop) {
        [orderedValues addObject:self[obj]];
    }];

    return [orderedValues copy];
}

@end
