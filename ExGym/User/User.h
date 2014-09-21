//
//  User.h
//  ExGym
//
//  Created by zrug on 14-9-21.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#ifndef ExGym_User_h
#define ExGym_User_h

@interface UserVars : NSObject {
    
}
+ (UserVars *)sharedInstance;

@property (nonatomic, strong) CBPeripheral *peripheral;


@end

#endif
