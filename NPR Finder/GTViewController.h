//
//  GTViewController.h
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTReverseGeocoder.h"

@interface GTViewController : UIViewController <GTReverseGeocoderDelegate>

- (void)restartReverseGeocoder;
- (void)shutDownReverseGeocoder;

@end
