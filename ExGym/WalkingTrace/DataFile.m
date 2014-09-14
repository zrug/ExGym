//
//  DataFile.m
//  officialDemo2D
//
//  Created by Zrug on 14-1-21.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "DataFile.h"
#import "Coords.h"

@implementation DataFile

@synthesize data;

+ (NSString *)fullPath {
    NSString *fileName = @"coords.dat";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}
- (NSString *)fullPath {
    NSString *fileName = @"coords.dat";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (id)initData {
    self = [super init];
    if (self) {
        self.data = [[NSMutableArray alloc] initWithContentsOfFile:[self fullPath]];
//        NSLog(@"DataFile initData fullPath: %@", [self fullPath]);
        if (!self.data) {
            self.data = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (Coords *)coordsWithIndex:(int)index {
    Coords *coords = [[Coords alloc] initWithData:[self.data objectAtIndex:index]];
    return coords;
}

- (BOOL)appendAndSaveCoords:(Coords *)coords {
    NSMutableArray *dataFile = [[NSMutableArray alloc] initWithContentsOfFile:[self fullPath]];

    if (!dataFile) {
        dataFile = [[NSMutableArray alloc] init];
    }

    NSDate * date = [NSDate new];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy-M-d h:m"];

    NSMutableDictionary *aData = [[NSMutableDictionary alloc] init];
    [aData setValue:@"Walking" forKey:@"title"];
    [aData setValue:[dateFormat stringFromDate:date] forKey:@"description"];
    [aData setValue:[coords contentsToStrings] forKey:@"contents"];
    [aData setValue:[NSNumber numberWithDouble:coords.distanceM] forKey:@"distanceM"];

    [self.data addObject:aData];
    [dataFile addObject:aData];

//    NSLog(@"%@", dataFile);

    if ( [dataFile writeToFile:[self fullPath] atomically:YES] ) {
//        NSLog(@"Write success!");
    } else {
//        NSLog(@"Write failed!");
    }
    return YES;
}

+ (void)removeAtLast:(int)rowIndex {
    NSMutableArray *dataFile = [[NSMutableArray alloc] initWithContentsOfFile:[self fullPath]];

    NSInteger index = [dataFile count] - 1 - rowIndex;
    [dataFile removeObjectAtIndex:index];
    
    if ( [dataFile writeToFile:[self fullPath] atomically:YES] ) {
//        NSLog(@"Write success!");
    } else {
//        NSLog(@"Write failed!");
    }
//    NSLog(@"DataFile removeAtLast index: %d", index);
}

@end
