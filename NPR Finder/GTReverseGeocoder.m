//
//  GTCityLookup.m
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

/* TO-DO
 *
 * Currently, this won't time out if it never finds a location or is never able to
 * get a good reverse geocode result. That definitely needs to be fixed.
 *
 * Also, the chain of method calls responsible for activating/halting the
 * locationManager is serious spaghetti.
 */

#import "GTReverseGeocoder.h"

@interface GTReverseGeocoder()

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSDate *timestamp;
@property (nonatomic) id<GTReverseGeocoderDelegate> delegate;
@property (nonatomic) CLLocation *currentLocation;

@end

@implementation GTReverseGeocoder

- (instancetype)init
{
    return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(id<GTReverseGeocoderDelegate>)delegate
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        _delegate = delegate;
        [self resetTimestamp];
    }
    
    return self;
}

- (void)resumeUpdating
{
    if (!_locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    [_locationManager startUpdatingLocation];
    [self resetTimestamp];
}

- (void)stopUpdating
{
    [_locationManager stopUpdatingLocation];
}

- (void)resetTimestamp
{
    _timestamp = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
}

- (void)updateCityWithLocation:(CLLocation *)location
{
    NSLog(@"updateCityWithLocation");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"reverseGeocodeLocation:completionHandler");
                       if (error.code == kCLErrorNetwork) {
                           NSLog(@"Error: application is making geocoder requests too frequently.");
                       } else if (error) {
                           NSLog(@"Reverse geocoder error: %@", error.localizedDescription);
                           self.currentCity = @"error";
                           if (_delegate) {
                               [_delegate currentCityDidChange:_currentCity];
                           }
                       } else {
                           // arbitrary choice of first object - if there is more than one object,
                           // the locations couldn't be resolved to a single location
                           CLPlacemark *placemark = [placemarks firstObject];
                           NSString *newCity = placemark.addressDictionary[@"City"];
                           NSLog(@"%@", newCity);
                           if (![_currentCity isEqualToString:newCity]) {
                               self.currentCity = newCity;
                               if (_delegate) {
                                   [_delegate currentCityDidChange:_currentCity];
                               }
                           }
                       }
                   }];

}

#pragma mark CLLocation delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations");
    // Apple specifically warns against sending more than one geocoder request
    // per minute, so keep a timestamp to avoid making too-frequent calls
    NSDate *currentTime = [[NSDate alloc] init];
    CLLocation *newLocation = [locations lastObject];
    if ((_currentLocation.coordinate.latitude != newLocation.coordinate.latitude ||
         _currentLocation.coordinate.longitude != newLocation.coordinate. longitude) &&
        [currentTime timeIntervalSinceDate:_timestamp] > 60) {
        
        [self updateCityWithLocation:newLocation];
        
        // get lat and lon for use constructing URL for API requests
        NSString *newLat = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
        if (![_currentLat isEqualToString:newLat]) {
            self.currentLat = newLat;
            if (_delegate && [_delegate respondsToSelector:@selector(currentLatDidChange:)]) {
                [_delegate currentLatDidChange:_currentLat];
            }
        }
        NSString *newLon = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
        if (![_currentLon isEqualToString:newLon]) {
            self.currentLon = newLon;
            if (_delegate && [_delegate respondsToSelector:@selector(currentLonDidChange:)]) {
                [_delegate currentLonDidChange:_currentLon];
            }
        }
        // not sure whether I could get away with using currentTime here
        self.timestamp = [[NSDate alloc] init];
        self.currentLocation = newLocation;
    }
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
                                                                 message:error.localizedFailureReason
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [errorAlert show];
        }
    }
}

@end
