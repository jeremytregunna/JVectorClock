//
//  JVectorClockTests.m
//  JGossip
//
//  Created by Jeremy Tregunna on 2013-04-06.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JVectorClockTests.h"
#import "JVectorClock.h"

#define ROOT_NODE_ID 12

@implementation JVectorClockTests
{
    uint32_t _nodeID;
    JVectorClock* _seed;
}

- (void)setUp
{
    [super setUp];

    _nodeID = 42;
    _seed = [[JVectorClock alloc] init];
}

- (void)testCreateClock
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    STAssertNotNil(clock, @"Create an instance");
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
    STAssertEqualObjects(prettyString, @"(42 = 1)", @"Pretty print");
}

- (void)testPrettyPrintMultiple
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    [clock forkClockForNodeID:ROOT_NODE_ID];
    [clock forkClockForNodeID:_nodeID];
    NSString* prettyString = [clock UTF8String];
    STAssertEqualObjects(prettyString, @"(12 = 1, 42 = 1)", @"Pretty print");
}

- (void)testFork
{
    JVectorClock* clock = [[JVectorClock alloc] init];
    [clock forkClockForNodeID:_nodeID];
    STAssertEqualObjects([clock UTF8String], @"(42 = 1)", @"Fork 1");
    [clock forkClockForNodeID:_nodeID];
    STAssertEqualObjects([clock UTF8String], @"(42 = 2)", @"Fork 2");
}

- (void)testMerge
{
    JVectorClock* clock1 = [[JVectorClock alloc] init];
    [clock1 forkClockForNodeID:ROOT_NODE_ID];
    JVectorClock* clock2 = [[JVectorClock alloc] init];
    [clock2 forkClockForNodeID:_nodeID];
    JVectorClock* newClock = [clock1 mergeClock:clock2];
    STAssertEqualObjects([newClock UTF8String], @"(12 = 1, 42 = 1)", @"Merge");
}

@end
