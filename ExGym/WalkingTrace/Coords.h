//
//  Coords.h
//  officialDemo2D
//
//  Created by Zrug on 13-12-16.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>

@class Coord;

@interface Coords : NSObject

@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, strong) NSMutableArray *cache_strings;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) NSTimeInterval totalSecond;

@property (nonatomic, assign) double distanceM;

- (id)initWithData:(NSDictionary *)data;
- (id)initWithUUID:(NSUUID *)uuid;
- (NSArray *)contentsToStrings;
- (BOOL)appendToDataFile;
- (BOOL)saveWithUUID:(NSUUID *)uuid;


- (void)cacheStringToContents;
- (double)speed;

- (NSMutableArray *)overlays;
- (MAPolyline *)lastOverlay;
- (MAPolyline *)overlayAtIndex:(int)index;
- (void)addCoord:(Coord *)coord;
- (void)restart;
- (void)clear;

@end
