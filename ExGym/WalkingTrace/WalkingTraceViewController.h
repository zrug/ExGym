//
//  WalkingTraceViewController.h
//  officialDemo2D
//
//  Created by Zrug on 13-12-16.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@class Coords;

@interface WalkingTraceViewController : UIViewController <MAMapViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;


-(void)newWalkingTrace;
-(void)walkingReview:(Coords *)coords;

-(void)load:(Coords *)coords;
- (void)prepareTrace;
-(void)startTrace;

@end
