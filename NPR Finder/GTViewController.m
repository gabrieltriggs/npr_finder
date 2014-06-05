//
//  GTViewController.m
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

#import "GTViewController.h"
#import "GTView.h"

@interface GTViewController ()

@property (nonatomic) GTReverseGeocoder *reverseGeocoder;

@end

@implementation GTViewController

- (void)updateStationData
{
    
}

- (void)restartReverseGeocoder
{
    if (!_reverseGeocoder) {
        _reverseGeocoder = [[GTReverseGeocoder alloc] initWithDelegate:self];
    }
    [_reverseGeocoder resumeUpdating];
}

- (void)shutDownReverseGeocoder
{
    [_reverseGeocoder stopUpdating];
}

- (void)loadView
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[GTView alloc] initWithFrame:appFrame];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    _reverseGeocoder = [[GTReverseGeocoder alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GTReverseGeocoder delegate methods
- (void)currentCityDidChange:(NSString *)newCity
{
    if ([newCity isEqualToString:@"error"]) {
        newCity = @"No nearby city. Using Lat/Long.";
    }
    [((GTView *) self.view) updateCity:newCity];
    [self updateStationData];
}

@end