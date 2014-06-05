//
//  GTNPRStation.m
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

#import "GTNPRStation.h"

@implementation GTNPRStation

- (instancetype)initWithID:(int)stationID
{
    if (self = [super init]) {
        self.stationID = stationID;
    }
    return self;
}

@end
