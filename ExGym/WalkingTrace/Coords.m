//
//  Coords.m
//  officialDemo2D
//
//  Created by Zrug on 13-12-16.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import "math.h"
#import "Coords.h"
#import "Coord.h"
#import "DataFile.h"
#import "ExGymDB.h"

@interface Coords()
- (double)distance:(Coord *)p1 to:(Coord *)p2;

@end


@implementation Coords

@synthesize cache_strings = _cache_strings;
@synthesize contents = _contents;
@synthesize title = _title;
@synthesize description = _description;

- (id)init {
    self = [super init];
    if (self) {
        self.contents = [[NSMutableArray alloc] init];
        self.cache_strings = [[NSMutableArray alloc] init];
        self.distanceM = 0.;
        self.totalSecond = 0.;
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    if (self) {
        self.contents = nil;
        self.cache_strings = [data objectForKey:@"contents"];
        self.title = [data objectForKey:@"title"];
        self.distanceM = [[data objectForKey:@"distanceM"] doubleValue];
        self.description = [data objectForKey:@"description"];
    }
    return self;
}

- (void)cacheStringToContents {
    self.contents = [[NSMutableArray alloc] init];
    self.distanceM = 0.;
    for (NSString *coordStr in self.cache_strings) {
        Coord *coord = [[Coord alloc] initWithString:coordStr];
        [self addCoord:coord];
    }
}

- (NSArray *)contentsToStrings {
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[self.contents count]];
    for (Coord *coord in self.contents) {
        [data addObject:[coord toString]];
    }
    return data;
}

- (BOOL)appendToDataFile {
    DataFile *file = [[DataFile alloc] initData];
    
    return [file appendAndSaveCoords:self];
}

- (id)initWithUUID:(NSUUID *)uuid {
    self = [self init];
    if (self) {
        self.contents = [[NSMutableArray alloc] init];
        self.distanceM = 0;
        ExGymDB *db = [ExGymDB instanceOfExGymDB];
        [db open];

        FMResultSet *rs = [db executeQuery:@"select * from coord where workoutid=? order by time", [uuid UUIDString]];
        while([rs next]) {
            CLLocationDegrees lati = [rs doubleForColumn:@"latitude"];
            CLLocationDegrees longi = [rs doubleForColumn:@"longitude"];
            NSDate *time = [rs dateForColumn:@"time"];
            Coord *coord = [[Coord alloc] initWithLat:lati andLng:longi andTime:time];
            [self addCoord:coord];
        }
        
        [db close];
        
    }
    return self;
}

- (BOOL)saveWithUUID:(NSUUID *)uuid {
    ExGymDB *db = [ExGymDB instanceOfExGymDB];
    [db open];

    for (Coord *coord in _contents) {
        NSLog(@"insert ing coord at time: %@", [coord time]);
        [db executeUpdate:@"insert into coord (workoutid, latitude, longitude, altitude, speed, time) values(?, ?, ?, ?, ?, ?)",
         [uuid UUIDString],
         [NSNumber numberWithDouble:coord.coordinate.latitude].stringValue,
         [NSNumber numberWithDouble:coord.coordinate.longitude].stringValue,
         [NSNumber numberWithDouble:0].stringValue,
         [NSNumber numberWithDouble:0].stringValue,
         [coord time]];
    }

    [db close];
    return YES;
}

- (MAPolyline *)polylineFrom:(Coord *)begin to:(Coord *)end {
    CLLocationCoordinate2D coords[2];
    
    coords[0].latitude = begin.coordinate.latitude;
    coords[0].longitude = begin.coordinate.longitude;

    coords[1].latitude = end.coordinate.latitude;
    coords[1].longitude = end.coordinate.longitude;

    return [MAPolyline polylineWithCoordinates:coords count:2];
}

- (MAPolyline *)lastOverlay {
    
    NSInteger coordsCount = [self.contents count];
    
    if (coordsCount < 2) {
        return nil;
    }
    Coord *begin = [self.contents objectAtIndex:coordsCount-2];
    Coord *end = [self.contents objectAtIndex:coordsCount-1];
    
    return [self polylineFrom:begin to:end];
}
- (MAPolyline *)overlayAtIndex:(int)index {
    
    if (index >= [self.contents count] - 1) {
        return nil;
    }
    Coord *begin = [self.contents objectAtIndex:index];
    Coord *end = [self.contents objectAtIndex:index + 1];
//    NSLog(@"overlayAtIndex:%i, with speed:%0.5f", index, end.speedFromPrev);
    return [self polylineFrom:begin to:end];
}

- (NSMutableArray *)overlays {

    NSInteger coordsCount = [self.contents count];

    if (coordsCount < 2) {
        return nil;
    }
    self.distanceM = 0.;

    NSMutableArray *lays = [[NSMutableArray alloc] initWithCapacity:coordsCount];
    
    for (int i=1; i<coordsCount; i++) {
        Coord *begin = [self.contents objectAtIndex:i-1];
        Coord *end = [self.contents objectAtIndex:i];
        self.distanceM += [self distance:begin to:end];
        [lays addObject:[self polylineFrom:begin to:end]];
    }
    return lays;
}

- (double)speed {
    NSLog(@"speed self.distanceM: %0.2f, self.totalSecond: %0.2f", self.distanceM, self.totalSecond);
    if (self.distanceM <= 0 || self.totalSecond <= 0) return 0;
    return (self.distanceM / self.totalSecond * 3600) / 1000;
}

- (void)addCoord:(Coord *)coord {

    if ([self.contents count] >= 1) {
        Coord *lastLoc = [self.contents objectAtIndex:(self.contents.count-1)];
        double oneDis = [self distance:lastLoc to:coord];
NSLog(@"addCoord oneDis: %0.2f", oneDis);
        self.distanceM += oneDis;
        coord.distanceFromPrev = oneDis;
        
        NSTimeInterval timeFromPrev = [[coord time] timeIntervalSinceDate:[lastLoc time]];
        self.totalSecond += timeFromPrev;
        [coord setSpeedFromPrev:[self speedFromDistanceM:oneDis andTimeInterval:timeFromPrev]];
    } else {
        self.distanceM = 0;
        self.totalSecond = 0;
        [coord setSpeedFromPrev:0];
    }
    
    [self.contents addObject:coord];
}

//- (void)contentsFromArray:(NSArray *)array {
//    NSMutableArray *_con = [[NSMutableArray alloc] initWithCapacity:[array count]];
//    
//    for (NSString *location in array) {
//        Coord *coord = [[Coord alloc] initWithString:location];
//        [_con addObject:coord];
//    }
//    
//    self.contents = _con;
//}

- (void)restart {
    [self.contents removeAllObjects];
    self.distanceM = 0;
}
- (void)clear {
    [self restart];
}

- (id)initWithData {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (double)speedFromDistanceM:(double)meter andTimeInterval:(double)second {
    return meter / second;
}

#define RAD(d)          (d * M_PI / 180.0)
#define EARTH_RADIUS    6378137.0
- (double)distance:(Coord *)p1 to:(Coord *)p2 {
    double result = 0.;
    
    CLLocationDegrees lat1 = p1.coordinate.latitude;
    CLLocationDegrees lat2 = p2.coordinate.latitude;
    CLLocationDegrees lng1 = p1.coordinate.longitude;
    CLLocationDegrees lng2 = p2.coordinate.longitude;

    double radLat1 = RAD(lat1);
    double radLat2 = RAD(lat2);
    double a = radLat1 - radLat2;
    double b = RAD(lng1) - RAD(lng2);
    double s = 2 * asin( sqrt( pow( sin( a / 2 ), 2 ) +
        cos( radLat1 ) * cos( radLat2 ) * pow( sin( b / 2 ), 2 ) ) );
    s = s * EARTH_RADIUS;
    result = round(s * 10000) / 10000;

    return result;
}
#undef EARTH_RADIUS
#undef RAD

@end
