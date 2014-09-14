//
//  DataFile.h
//  officialDemo2D
//
//  Created by Zrug on 14-1-21.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Coords;

@interface DataFile : NSObject

@property (nonatomic, strong) NSMutableArray *data;

- (NSString *)fullPath;

// init
- (id)initData;

// append & save
- (BOOL)appendAndSaveCoords:(Coords *)coords;

// delete
+ (void)removeAtLast:(int)rowIndex;

// get
- (Coords *)coordsWithIndex:(int)index;

@end
