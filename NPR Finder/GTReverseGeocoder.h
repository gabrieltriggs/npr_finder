//
//  GTCityLookup.h
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class GTReverseGeocoder;
@protocol GTReverseGeocoderDelegate <NSObject>

@required
- (void)currentCityDidChange:(NSString *)newCity;
@optional
- (void)currentLatDidChange:(NSString *)newLat;
- (void)currentLonDidChange:(NSString *)newLon;

@end


@interface GTReverseGeocoder : NSObject <CLLocationManagerDelegate>

@property (nonatomic) NSString *currentLat;
@property (nonatomic) NSString *currentLon;
@property (nonatomic) NSString *currentCity;

- (instancetype)initWithDelegate:(id<GTReverseGeocoderDelegate>)delegate;
- (void)resumeUpdating;
- (void)stopUpdating;

@end
