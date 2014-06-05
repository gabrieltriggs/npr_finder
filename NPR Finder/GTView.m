//
//  GTView.m
//  NPR Finder
//
//  Created by Gabriel Triggs on 6/4/14.
//  Copyright (c) 2014 Gabriel Triggs. All rights reserved.
//

#import "GTView.h"

@interface GTView()
@property (nonatomic) UILabel *cityLabel;
@end

@implementation GTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc] initWithFrame:
                                   CGRectMake(0, 0, frame.size.width,                                                                           frame.size.height + 20)];
        background.contentMode = UIViewContentModeScaleAspectFill;
        NSString *imageName = self.frame.size.height == 960 ? @"bg.png" : @"bgShort.png";
        background.image = [UIImage imageNamed:imageName];
        float borderSize = self.frame.size.width / 16;
        
        UILabel *stationsNearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 20, 320, 46)];
        stationsNearLabel.textColor = [UIColor whiteColor];
        stationsNearLabel.font = [UIFont fontWithName:@"Avenir-Light" size:33];
        stationsNearLabel.textAlignment = NSTextAlignmentCenter;
        stationsNearLabel.text = @"Stations Near";
        
        float cityLabelWidth = self.frame.size.width - 2 * borderSize;
        NSLog(@"%f", cityLabelWidth);
        self.cityLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake((self.frame.size.width - cityLabelWidth) / 2,
                                 0 + 20 + 34,
                                 cityLabelWidth,
                                 stationsNearLabel.frame.origin.y + 54)];
        NSLog(@"%f", _cityLabel.frame.origin.x);
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.font = [UIFont fontWithName:@"Avenir-Light" size:33];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        _cityLabel.adjustsFontSizeToFitWidth = YES;
        _cityLabel.minimumScaleFactor = 0.5;
        _cityLabel.text = @"Minneapolis";
        
        UIView *overlay = [[UIView alloc] initWithFrame:
                           CGRectMake(borderSize,
                                      borderSize + _cityLabel.frame.origin.y + 61,
                                      frame.size.width - 2 * borderSize,
                                      frame.size.height + 20 - 2 * borderSize -
                                        (_cityLabel.frame.origin.y + 61))];
        overlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
        
        [self addSubview:background];
        [self addSubview:stationsNearLabel];
        [self addSubview:_cityLabel];
        [self addSubview:overlay];
    }
    return self;
}

@end
