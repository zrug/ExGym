//
//  Coord.m
//  officialDemo2D
//
//  Created by Zrug on 14-1-23.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "Coord.h"

@interface Coord()

@property (nonatomic, strong) NSDate *datetime;

@end

@implementation Coord

- (NSDate *)time {
    return self.datetime;
}

- (NSTimeInterval)timeInterval {
    return [self.datetime timeIntervalSince1970];
}

- (void)setCoordinateWithLat:(CLLocationDegrees)latitude andLong:(CLLocationDegrees)longitude {
//    NSLog(@"Coord setCoordinate");
    self.datetime = [NSDate date];
    CLLocationCoordinate2D cod;
    cod.latitude = latitude;
    cod.longitude = longitude;
    self.coordinate = cod;
}

- (NSString *)toString {
    NSLog(@"%@", [NSString stringWithFormat:@"%f, %f, %f", self.coordinate.latitude, self.coordinate.longitude, [self timeInterval]]);
    return [NSString stringWithFormat:@"%f, %f, %f", self.coordinate.latitude, self.coordinate.longitude, [self timeInterval]];
}

- (id)initWithString:(NSString *)initString {
    self = [super init];
    if (self) {
        NSArray *arr = [initString componentsSeparatedByString:@", "];
        
        CLLocationDegrees latitude = [[arr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[arr objectAtIndex:1] doubleValue];
        [self setCoordinateWithLat:latitude andLong:longitude];
        
        double timeInterval = [[arr objectAtIndex:2] doubleValue];
        self.datetime = [NSDate dateWithTimeIntervalSince1970:timeInterval];

        self.distanceFromPrev = 0;

        self.overlayColorFromPrev = [UIColor colorWithRed:0. green:1. blue:0. alpha:1.];
    }
    return self;
}

- (id)initWithLat:(CLLocationDegrees)latitude andLng:(CLLocationDegrees)longtitude andTime:(NSDate *)time {
    self = [super init];
    if (self) {
        [self setLat:latitude andLng:longtitude andTime:time];
    }
    return self;
}

- (void)setLat:(CLLocationDegrees)latitude andLng:(CLLocationDegrees)longtitude andTime:(NSDate *)time {
    [self setCoordinateWithLat:latitude andLong:longtitude];
    self.datetime = time;
    self.distanceFromPrev = 0;
    self.overlayColorFromPrev = [UIColor colorWithRed:0. green:1. blue:0. alpha:1.];
}


- (void)setSpeedFromPrev:(double)speed {
    // NSLog(@"setSpeedFromPrev: %f, time:%@", speed, self.datetime);
    _speedFromPrev = speed;

}

@end

