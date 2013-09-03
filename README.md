# JVectorClock
Copyright © 2013, Jeremy Tregunna, All Rights Reserved.

JVectorClock is an implementation of a [Vector Clock](http://en.wikipedia.org/wiki/Vector_clock) written in Objective-C. Vector clocks are useful when building distributed systems.

[![Build Status](https://travis-ci.org/jeremytregunna/JVectorClock.png?branch=master)](https://travis-ci.org/jeremytregunna/JVectorClock)

## Installation

However you want to install it is well, a matter left up to your better judgement. There are no external dependencies you have to account for, other than basic framework level support.

## Usage

All vector clocks start out with a value of `0`. You can create a new empty clock by allocating an instance like so:

    JVectorClock* clock = [[JVectorClock alloc] init];

In this state, we can issue a fork passing in a node ID (the node which triggered the event) like this, assuming the node ID is 42:

    [clock forkClockForNodeID:42];

From here, we can see the value of our clock by asking for the `UTF8String`:

    NSLog(@"%@", [clock UTF8String]);

This should print out `(42 = 1)`. If we have another clock like this:

    JVectorClock* other = [[JVectorClock alloc] init];
    [other forkClockForNodeID:12];
    [other forkClockForNodeID:12]; // Two events!

We can merge them together into a new vector clock by calling the `mergeClock:` method:

    JVectorClock* newClock = [clock mergeClock:other];

Finally we can see that this actually took effect by looking at the output using `UTF8String` again:

    NSLog(@"%@", [newClock UTF8String]);

We should see `(42 = 1, 12 = 2)`.

## License

The terms under which use and distribution of this library is governed may be found in the [LICENSE](https://github.com/jeremytregunna/JVectorClock/blob/master/LICENSE) file.
