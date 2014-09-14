//
//  Coord.h
//  officialDemo2D
//
//  Created by Zrug on 14-1-23.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>

@interface Coord : MAUserLocation

@property (nonatomic, assign) double distanceFromPrev;
@property (nonatomic, assign) double speedFromPrev;
@property (nonatomic, assign) UIColor *overlayColorFromPrev;

- (NSDate *)time;
- (NSTimeInterval)timeInterval;

- (void)setCoordinateWithLat:(CLLocationDegrees)latitude andLong:(CLLocationDegrees)longitude;

- (NSString *)toString;
- (id)initWithString:(NSString *)location;

- (void)setSpeedFromPrev:(double)speed;


@end

