//
//  UserModel.h
//  ExGym
//
//  Created by zrug on 14-10-8.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface UserModel : NSObject

@property (nonatomic, retain) NSUUID *guid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, retain) NSDate *birthday;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, retain) NSNumber *bpmtop;
@property (nonatomic, copy) NSString *password;

-(id)init;

- (bool)save;
- (NSDictionary *)toDict;


@end
