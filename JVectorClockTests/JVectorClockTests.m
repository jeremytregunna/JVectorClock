//
//  JVectorClockTests.m
//  JGossip
//
//  Created by Jeremy Tregunna on 2013-04-06.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JVectorClockTests.h"
#import "JVectorClock.h"

@implementation JVectorClockTests
{
    NSUUID* _nodeID;
    NSUUID* _rootNodeID;
    JVectorClock* _seed;
}

- (void)setUp
{
    [super setUp];

    _nodeID = [[NSUUID alloc] initWithUUIDString:@"1CCE57EC-9E5F-41DE-8E33-2A1C203E6F4E"];
    _rootNodeID = [[NSUUID alloc] initWithUUIDString:@"BA6B6C5D-3894-4BF6-AB28-863A6488A1BB"];
    _seed = [[JVectorClock alloc] init];
}

- (void)testCreateClock
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    STAssertNotNil(clock, @"Create an instance");
}

- (void)testNewClockHasValueOfZero
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    STAssertEquals([clock clockValueForNodeID:_nodeID], (NSUInteger)0, @"New clocks have a value of 0");
}

- (void)testKnownClockHasValueOfTwo
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    [clock forkClockForNodeID:_nodeID];
    [clock forkClockForNodeID:_nodeID];
    STAssertEquals([clock clockValueForNodeID:_nodeID], (NSUInteger)2, @"Clocks increment their clock value on fork events");
}

- (void)testSeedPrettyPrint
{
    NSString* prettyString = [_seed UTF8String];
    STAssertEqualObjects(prettyString, @"()", @"Pretty print seed");
}

- (void)testPrettyPrint
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    [clock forkClockForNodeID:_nodeID];
    NSString* prettyString = [clock UTF8String];
    STAssertEqualObjects(prettyString, @"(1CCE57EC-9E5F-41DE-8E33-2A1C203E6F4E = 1)", @"Pretty print");
}

- (void)testPrettyPrintMultiple
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    [clock forkClockForNodeID:_rootNodeID];
    [clock forkClockForNodeID:_nodeID];
    NSString* prettyString = [clock UTF8String];
    STAssertEqualObjects(prettyString, @"(BA6B6C5D-3894-4BF6-AB28-863A6488A1BB = 1, 1CCE57EC-9E5F-41DE-8E33-2A1C203E6F4E = 1)", @"Pretty print");
}

- (void)testFork
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    [clock forkClockForNodeID:_nodeID];
    STAssertEqualObjects([clock UTF8String], @"(1CCE57EC-9E5F-41DE-8E33-2A1C203E6F4E = 1)", @"Fork 1");
    [clock forkClockForNodeID:_nodeID];
    STAssertEqualObjects([clock UTF8String], @"(1CCE57EC-9E5F-41DE-8E33-2A1C203E6F4E = 2)", @"Fork 2");
}

- (void)testMerge
{
    JVectorClock* clock1 = [[JVectorClock alloc] init];
    [clock1 forkClockForNodeID:_rootNodeID];
    JVectorClock* clock2 = [[JVectorClock alloc] init];
    [clock2 forkClockForNodeID:_nodeID];
    JVectorClock* newClock = [clock1 mergeClock:clock2];
    STAssertEqualObjects([newClock UTF8String], @"(BA6B6C5D-3894-4BF6-AB28-863A6488A1BB = 1, 1CCE57EC-9E5F-41DE-8E33-2A1C203E6F4E = 1)", @"Merge");
}

@end
