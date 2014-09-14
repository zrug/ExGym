//
//  WalkingTraceViewController.m
//  officialDemo2D
//
//  Created by Zrug on 13-12-16.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import "WalkingTraceViewController.h"
#import "Coords.h"
#import "Coord.h"
#import "CommonUtility.h"

@interface WalkingTraceViewController () {
    NSDate *timer;
    BOOL tracker;
    double speedColor;
    NSArray *colorTable;
}

@property (nonatomic, strong) UILabel *lbDistance;
@property (nonatomic, strong) UILabel *lbUpdatingLocation;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIButton *btnRestart;

@property (nonatomic, strong) NSMutableArray *overlays;
@property (nonatomic, strong) Coords *coords;

@end


@implementation WalkingTraceViewController

@synthesize lbDistance = _lbDistance;
@synthesize lbUpdatingLocation = _lbUpdatingLocation;
@synthesize mapView = _mapView;
@synthesize overlays = _overlays;
@synthesize coords = _coords;
@synthesize btnRestart = _btnRestart;
@synthesize btnSave = _btnSave;

- (void)clearMapView
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.coords clear];
}
- (void)offMapView
{
    self.mapView.showsUserLocation = NO;
}
- (void)onMapView
{
    self.mapView.showsUserLocation = YES;
}

- (void)initDistance {
    CGRect distanceFrame = CGRectMake(15, 30, 160, 30);
    self.lbDistance.frame = distanceFrame;
    self.lbDistance.font = [UIFont systemFontOfSize:26.0];
    self.lbDistance.textColor = [UIColor colorWithRed:.2 green:.1 blue:1 alpha:1];
    self.lbDistance.shadowColor = [UIColor whiteColor];
    self.lbDistance.shadowOffset = CGSizeMake(1, 1);
    self.lbDistance.textAlignment = NSTextAlignmentLeft;
    [self.lbDistance setText:@"0.0"];
    [self.view addSubview:self.lbDistance];
}

- (void)initUpdatingLocation {
//    CGRect updatingFrame = CGRectMake(15, 60, 160, 20);
//    self.lbUpdatingLocation.frame = updatingFrame;
//    self.lbUpdatingLocation.font = [UIFont systemFontOfSize:9.0];
//    self.lbUpdatingLocation.textColor = [UIColor colorWithRed:.2 green:.1 blue:1 alpha:1];
//    self.lbUpdatingLocation.shadowColor = [UIColor whiteColor];
//    self.lbUpdatingLocation.shadowOffset = CGSizeMake(1, 1);
//    self.lbUpdatingLocation.textAlignment = NSTextAlignmentLeft;
//    [self.lbUpdatingLocation setText:@""];
//    [self.view addSubview:self.lbUpdatingLocation];
}

- (void)initButtons {

//    Save and Restart button at bottom of the MapView, no use now

//    CGRect mapViewBounds = self.mapView.bounds;

//    self.btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    CGSize btnSaveSize = CGSizeMake(70, 40);
//    [self.btnSave setFrame:CGRectMake( mapViewBounds.origin.x + 15,
//                    mapViewBounds.size.height - btnSaveSize.height - 15,
//                    btnSaveSize.width, btnSaveSize.height )];
//    [self.btnSave setTitle:@"Save" forState:UIControlStateNormal];
//    [self.btnSave addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
//    [self.mapView addSubview:self.btnSave];

//    self.btnRestart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//
//    CGSize btnRestartSize = CGSizeMake(80, 40);
//    [self.btnRestart setFrame:CGRectMake( self.mapView.bounds.size.width - btnRestartSize.width - 15,
//                    self.mapView.bounds.size.height - btnRestartSize.height - 15,
//                    btnRestartSize.width, btnRestartSize.height )];
//    [self.btnRestart setTitle:@"Restart" forState:UIControlStateNormal];
//    [self.btnRestart addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
//    [self.mapView addSubview:self.btnRestart];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonSystemItemCancel target:self action:@selector(goback:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonSystemItemSave target:self action:@selector(save:)];
}

-(void)load:(Coords *)aCoords {
    self.title = @"轨迹回顾";
    [self clearMapView];
    [self offMapView];
    tracker = NO;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    self.coords = aCoords;
    [self.coords cacheStringToContents];
    
    [self.lbDistance setText:[NSString stringWithFormat:@"%0.2f", [self.coords distanceM]]];
    
    NSArray *overlays = [self.coords overlays];
    if (overlays) {
        for (int i = (int)self.coords.contents.count - 2; i >= 0 ; i--) {
            MAPolyline *overlay = [self.coords overlayAtIndex:i];
            speedColor = [[self.coords.contents objectAtIndex:i + 1] speedFromPrev];
            [self.mapView addOverlay:overlay];
        }
        // [self.mapView addOverlays:overlays];
        MAMapRect mapRect = [CommonUtility mapRectForOverlays:overlays];
        self.mapView.visibleMapRect = mapRect;
    }
}

- (void)save:(id)sender {
    [self.coords appendToDataFile];
    [self.coords clear];
    [self offMapView];
    [self clearMapView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)restart:(id)sender {
    [self.coords restart];
    [self clearMapView];
    [self onMapView];
}

-(void)goback:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"放弃并返回"
                                            message:@"记录的轨迹将会丢失，真的要返回吗？"
                                            delegate:self 
                                            cancelButtonTitle:@"Yes"
                                            otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)setDistanceText:(double)distanceM {
    NSString *distance = [NSString stringWithFormat:@"%0.2f", distanceM];
    [self.lbDistance setText:distance];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.coords clear];
        [self offMapView];
        [self clearMapView];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initMapView
{
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSLog(@"WalkingTraceViewController initWithNibName");
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        // 66ff33, b2ff1a, f7ff03, ffe600, ff8c00, ff0d00
        colorTable = [NSArray arrayWithObjects:
                      [UIColor colorWithRed:0x66/255. green:1 blue:0x33/255. alpha:.3],
                      [UIColor colorWithRed:0xb2/255. green:1 blue:0x1a/255. alpha:.3],
                      [UIColor colorWithRed:0xf7/255. green:1 blue:0x03/255. alpha:.3],
                      [UIColor colorWithRed:1 green:0xe6/255 blue:0 alpha:.3],
                      [UIColor colorWithRed:1 green:0xc0/255 blue:0 alpha:.3],
                      [UIColor colorWithRed:1 green:0x0d/255 blue:0 alpha:.3],
                      nil];

        self.mapView = [[MAMapView alloc] init];
        self.mapView.delegate = self;
        self.coords = [[Coords alloc] init];
        self.overlays = [NSMutableArray array];
        self.lbDistance = [[UILabel alloc] initWithFrame:CGRectZero];
        self.lbUpdatingLocation = [[UILabel alloc] initWithFrame:CGRectZero];
        timer = [NSDate date];
        tracker = NO;
        
        [self initMapView];
        [self initDistance];
//        [self initUpdatingLocation];
    }
    return self;
}

- (void)prepareTrace {
//    NSLog(@"wtvc prepareTrace");
    self.title = @"准备中 ...";
    tracker = NO;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self onMapView];
}
- (void)startTrace {
//    NSLog(@"wtvc startTrace");
    self.title = @"轨迹记录中 ...";
    tracker = YES;
    [self clearMapView];
    [self setDistanceText:0.];
    [self onMapView];
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self initButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIColor *)colorWithSpeed:(double)speed {
    int index = (int)speed / -2;
    if (index > 5) index = 5;
    NSLog(@"colorWithSpeed: %i", index);
    return [colorTable objectAtIndex:index];
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 10.f;
//        polylineView.strokeColor = [UIColor colorWithRed:.2 green:.1 blue:1 alpha:.8];

        NSLog(@"mapView viewForOverlay speedColor: %0.0f", speedColor);
        polylineView.strokeColor = [self colorWithSpeed:speedColor];
        
        return polylineView;
    }
    
    return nil;
}

-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"didFailToLocateUserWithError:%@, %@", error.description, error.localizedFailureReason);
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {

    if (tracker) {

        if (updatingLocation) {
        
            [self.lbUpdatingLocation setText:@"updateingLocation ..."];
        
        } else {

            [self.lbUpdatingLocation setText:@""];
            double since = [timer timeIntervalSinceNow];

            if (since < -3.8) {
                Coord *coord = [[Coord alloc] init];
                [coord setCoordinateWithLat:userLocation.coordinate.latitude andLong:userLocation.coordinate.longitude];
                NSLog(@"coord: [%0.9f] [%0.9f]", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
                // TODO: set speed color
                
                speedColor = coord.speedFromPrev;
                [self.coords addCoord:coord];
                [self.mapView addOverlay:[self.coords lastOverlay]];
                [self setDistanceText:self.coords.distanceM];
                timer = [NSDate date];
            }
        }
    } else {
//        NSLog(@"wtvc trace waiting ...");
    }
    
}

-(void)newWalkingTrace {
}

-(void)walkingReview:(Coords *)coords {
}


@end
