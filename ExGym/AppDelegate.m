//
//  AppDelegate.m
//  ExGym
//
//  Created by zrug on 14-8-30.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>
#import "FMDB.h"

@implementation AppDelegate

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *name   = [NSString stringWithFormat:@"\nSDKVersion:%@\nFILE:%s\nLINE:%d\nMETHOD:%s", [MAMapServices sharedServices].SDKVersion, __FILE__, __LINE__, __func__];
        NSString *reason = [NSString stringWithFormat:@"请首先配置APIKey.h中的APIKey, 申请APIKey参考见 http://api.amap.com"];
        
        @throw [NSException exceptionWithName:name
                                       reason:reason
                                     userInfo:nil];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self configureAPIKey];
    [self makeDatabase];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:37/255. green:217/255. blue:235/255. alpha:1];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)makeDatabase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"exgym.sqlite"];
    
    NSLog(@"db spec: %@", writableDBPath);
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    [db open];
    
    NSString* create_table_workout = @"CREATE TABLE IF NOT EXISTS \"workout\" (\"guid\" VARCHAR(36) PRIMARY KEY  NOT NULL  UNIQUE , \"type\" TEXT NOT NULL , \"distance\" REAL NOT NULL  DEFAULT 0, \"duration\" REAL NOT NULL  DEFAULT 0, \"kcal\" REAL NOT NULL  DEFAULT 0, \"pace\" INTEGER NOT NULL  DEFAULT 0, \"avgspeed\" REAL NOT NULL  DEFAULT 0, \"topspeed\" REAL NOT NULL  DEFAULT 0, \"avgheartrate\" INTEGER NOT NULL  DEFAULT 0, \"topheartrate\" INTEGER NOT NULL  DEFAULT 0, \"mood\" TEXT, \"temperature\" INTEGER, \"weather\" TEXT, \"remarks\" TEXT, \"createddate\" TEXT NOT NULL  DEFAULT CURRENT_DATE, \"createdtime\" TEXT DEFAULT CURRENT_TIME)";
    [db executeUpdate:create_table_workout];
    
    NSString *create_table_heartrate = @"CREATE TABLE IF NOT EXISTS \"heartrate\" (\"workoutid\" VARCHAR(36) NOT NULL , \"rate\" INTEGER NOT NULL  DEFAULT 0, \"time\" INTEGER NOT NULL )";
    [db executeUpdate:create_table_heartrate];
    
    NSString *create_table_coord = @"CREATE TABLE IF NOT EXISTS \"coord\" (\"workoutid\" VARCHAR(36) NOT NULL , \"latitude\" REAL NOT NULL  DEFAULT 0, \"longitude\" REAL NOT NULL  DEFAULT 0, \"altitude\" REAL NOT NULL  DEFAULT 0, \"speed\" REAL NOT NULL  DEFAULT 0, \"time\" INTEGER NOT NULL )";
    [db executeUpdate:create_table_coord];
    
    [db close];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
