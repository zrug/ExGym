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

@property (nonatomic, assign) double distanceM;

- (id)initWithData:(NSDictionary *)data;
- (NSArray *)contentsToStrings;
- (BOOL)appendToDataFile;

- (void)cacheStringToContents;

- (NSMutableArray *)overlays;
- (MAPolyline *)lastOverlay;
- (MAPolyline *)overlayAtIndex:(int)index;
- (void)addCoord:(Coord *)coord;
- (void)restart;
- (void)clear;

@end
