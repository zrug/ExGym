//
//  User.m
//  ExGym
//
//  Created by zrug on 14-9-21.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@implementation UserVars

+(UserVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static UserVars *instance = nil;
    dispatch_once( &onceToken, ^{
        instance = [[UserVars alloc] init];
    } );
    return instance;
}

-(id) init {
    self = [super init];
    if (self) {
        _peripheral = nil;
    }
    return self;
}

@end