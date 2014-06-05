//
//  GTNPRStation.h
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTNPRStation : NSObject

typedef enum { kWeak = 1,
               kModerate = 3,
               kStrong = 5 } SignalStrength;

@property (nonatomic)       int stationID;
@property (nonatomic, copy) NSString *callLetters;
@property (nonatomic)       NSString *band;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *frequency;
@property (nonatomic, copy) NSString *marketCity;
@property (nonatomic)       SignalStrength signal;
@property (nonatomic, copy) NSString *tagline;

- (instancetype)initWithID:(int)stationID;

@end
