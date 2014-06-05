//
//  GTCityLookup.m
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

#import "GTCityLookup.h"

@interface GTCityLookup()
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation GTCityLookup

- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return self;
}

#pragma mark CLLocation delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // make timestamp to avoid doing reverse geocoding more than once/minute
    // update location to locations[0]
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:didFailWithError:%@", error);
    
    if ([error.domain isEqualToString:@"kCLErrorDomain"]) {
        if (error.code == kCLErrorLocationUnknown) {
            // nothing to do here - location manager will continue trying to find location
        } else if (error.code == kCLErrorDenied) {
            [manager stopUpdatingLocation];
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Location"
                                                                 message:@"Please navigate to the Settings app and give NPR Finder permission to see location data."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [errorAlert show];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Location"
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [errorAlert show];
        }
    }
}

@end
