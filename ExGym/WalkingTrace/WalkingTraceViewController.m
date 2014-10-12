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
#import "User.h"
#import "CommonUtility.h"

#define POLARH7_HRM_DEVICE_INFO_SERVICE_UUID @"180A"
#define POLARH7_HRM_HEART_RATE_SERVICE_UUID @"180D"

#define POLARH7_HRM_MEASUREMENT_CHARACTERISTIC_UUID @"2A37"
#define POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID @"2A38"
#define POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID @"2A29"

#define ledRectLeftTop CGRectMake(0, 0, 160, 70);
#define ledRectLeftMid CGRectMake(0, 70, 160, 70);
#define ledRectLeftBtm CGRectMake(0, 140, 160, 70);
#define ledRectRightTop CGRectMake(160, 0, 160, 70);
#define ledRectRightMid CGRectMake(160, 70, 160, 70);
#define ledRectRightBtm CGRectMake(160, 140, 160, 70);


@interface WalkingTraceViewController () {
    NSDate *timer;
    BOOL tracker;
    double speedColor;
    NSArray *colorTable;
    CLLocationManager *locationManager;
    BOOL infoViewIsOpen;
    BOOL inAnimation;
}

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UILabel *lbDistance;
@property (nonatomic, strong) UILabel *lbBpm;
@property (nonatomic, strong) UILabel *lbKcal;
@property (nonatomic, strong) UILabel *lbPace;
@property (nonatomic, strong) UILabel *lbSpeed;
@property (nonatomic, strong) UILabel *lbTotalTime;

@property (nonatomic, strong) UIView *distanceView;
@property (nonatomic, strong) UIView *bmpView;
@property (nonatomic, strong) UIView *kcalView;
@property (nonatomic, strong) UIView *paceView;
@property (nonatomic, strong) UIView *speedView;
@property (nonatomic, strong) UIView *totalTimeView;

@property (nonatomic, strong) UIImage *imageUp;
@property (nonatomic, strong) UIImage *imageDown;

@property (nonatomic, strong) UIButton *updown;

@property (nonatomic, strong) UILabel *lbUpdatingLocation;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIButton *btnRestart;

@property (nonatomic, strong) NSMutableArray *overlays;
@property (nonatomic, strong) Coords *coords;

@end


@implementation WalkingTraceViewController

@synthesize mapView = _mapView;
@synthesize overlays = _overlays;
@synthesize coords = _coords;
@synthesize btnRestart = _btnRestart;
@synthesize btnSave = _btnSave;
@synthesize infoView = _infoView;

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

- (void)initInfos {
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    _infoView.backgroundColor = [UIColor whiteColor];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:_infoView.bounds];
    bg.image = [UIImage imageNamed:@"infoViewBG.jpg"];
    [_infoView addSubview:bg];
    
    [_infoView addSubview:[self viewOfDistance]];
    [_infoView addSubview:[self viewOfBpm]];
    [_infoView addSubview:[self viewOfPace]];
    [_infoView addSubview:[self viewOfKcal]];
    [_infoView addSubview:[self viewOfTotalTime]];
    [_infoView addSubview:[self viewOfSpeed]];
    
    _imageUp = [UIImage imageNamed:@"icon-flapup"];
    _imageDown = [UIImage imageNamed:@"icon-flapdown"];
    
    _updown = [UIButton buttonWithType:UIButtonTypeCustom];
    _updown.frame = CGRectMake(140, 190, 40, 40);
    [_updown setImage:_imageUp forState:UIControlStateNormal];
    [_updown addTarget:self action:@selector(infoViewUpDown) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:_updown];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(infoViewClose)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(infoViewOpen)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    [self.view addSubview:self.infoView];
    
    infoViewIsOpen = YES;
    inAnimation = NO;
}

- (void) infoViewUpDown {
    if (!inAnimation) {
        if (infoViewIsOpen) {
            [self infoViewClose];
        } else {
            [self infoViewOpen];
        }
    }
}

- (void) infoViewClose {
    if (infoViewIsOpen && !inAnimation) {
        inAnimation = !inAnimation;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
            CGRect frame = _infoView.frame;
            frame.origin.y -= 195;
            _infoView.frame = frame;
            
            frame = self.view.bounds;
            self.mapView.frame = frame;
        } completion:^(BOOL finished) {
            infoViewIsOpen = !infoViewIsOpen;
            inAnimation = !inAnimation;
            [_updown setImage:_imageDown forState:UIControlStateNormal];
        }];
    }
}

- (void) infoViewOpen {
    if (!infoViewIsOpen && !inAnimation) {
        inAnimation = !inAnimation;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
            CGRect frame = _infoView.frame;
            frame.origin.y += 195;
            _infoView.frame = frame;

            frame = CGRectMake(0, 210, 320, self.view.bounds.size.height - 210);
            self.mapView.frame = frame;
        } completion:^(BOOL finished) {
            infoViewIsOpen = !infoViewIsOpen;
            inAnimation = !inAnimation;
            [_updown setImage:_imageUp forState:UIControlStateNormal];
        }];
    }
}

- (UIView *) viewOfDistance {
    if (!_distanceView) {
        _distanceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 70)]; // Left Top
//        _distanceView.layer.borderWidth = 1.0;
//        _distanceView.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
        cellIcon.image = [UIImage imageNamed:@"icon-distance"];
        [_distanceView addSubview:cellIcon];
        
        UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(111, 24, 40, 30)];
        unit.font = [UIFont fontWithName:@"DINCond-Medium" size:12.0];
        unit.textAlignment = NSTextAlignmentLeft;
        unit.text = @"公里";
        [_distanceView addSubview:unit];
        
        _lbDistance = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 60, 30)];
        _lbDistance.font = [UIFont fontWithName:@"DINPro-Medium" size:28.0];
        _lbDistance.textColor = [UIColor blackColor];
        _lbDistance.shadowColor = [UIColor whiteColor];
        _lbDistance.shadowOffset = CGSizeMake(1, 1);
        _lbDistance.textAlignment = NSTextAlignmentRight;
        [_lbDistance setText:@"--"];
        [_distanceView addSubview:_lbDistance];
    }
    return _distanceView;
}
- (UIView *) viewOfSpeed {
    if (!_speedView) {
        _speedView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 160, 70)]; // Left Middle
//        _speedView.layer.borderWidth = 1.0;
//        _speedView.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
        cellIcon.image = [UIImage imageNamed:@"icon-speed"];
        [_speedView addSubview:cellIcon];

        UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(111, 24, 40, 30)];
        unit.font = [UIFont fontWithName:@"DINCond-Medium" size:12.0];
        unit.textAlignment = NSTextAlignmentLeft;
        unit.text = @"公里/时";
        [_speedView addSubview:unit];

        _lbSpeed = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 60, 30)];
        _lbSpeed.font = [UIFont fontWithName:@"DINPro-Medium" size:28.0];
        _lbSpeed.textColor = [UIColor blackColor];
        _lbSpeed.shadowColor = [UIColor whiteColor];
        _lbSpeed.shadowOffset = CGSizeMake(1, 1);
        _lbSpeed.textAlignment = NSTextAlignmentRight;
        [_lbSpeed setText:@"--"];
        [_speedView addSubview:_lbSpeed];

    }
    return _speedView;
}
- (UIView *) viewOfKcal {
    if (!_kcalView) {
        _kcalView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, 160, 70)]; // Left Bottom
//        _kcalView.layer.borderWidth = 1.0;
//        _kcalView.layer.borderColor = [UIColor grayColor].CGColor;

        UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
        cellIcon.image = [UIImage imageNamed:@"icon-kcal"];
        [_kcalView addSubview:cellIcon];
        
        UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(111, 24, 40, 30)];
        unit.font = [UIFont fontWithName:@"DINCond-Medium" size:12.0];
        unit.textAlignment = NSTextAlignmentLeft;
        unit.text = @"卡路里";
        [_kcalView addSubview:unit];
        
        _lbKcal = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 60, 30)];
        _lbKcal.font = [UIFont fontWithName:@"DINPro-Medium" size:28.0];
        _lbKcal.textColor = [UIColor blackColor];
        _lbKcal.shadowColor = [UIColor whiteColor];
        _lbKcal.shadowOffset = CGSizeMake(1, 1);
        _lbKcal.textAlignment = NSTextAlignmentRight;
        [_lbKcal setText:@"--"];
        [_kcalView addSubview:_lbKcal];
        
    }
    return _kcalView;
}
- (UIView *) viewOfTotalTime {
    if (!_totalTimeView) {
        _totalTimeView = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, 70)]; // Right Top
//        _totalTimeView.layer.borderWidth = 1.0;
//        _totalTimeView.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
        cellIcon.image = [UIImage imageNamed:@"icon-totaltime"];
        [_totalTimeView addSubview:cellIcon];
        
        _lbTotalTime = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 100, 30)];
        _lbTotalTime.font = [UIFont fontWithName:@"DINPro-Medium" size:26.0];
        _lbTotalTime.textColor = [UIColor blackColor];
        _lbTotalTime.shadowColor = [UIColor whiteColor];
        _lbTotalTime.shadowOffset = CGSizeMake(1, 1);
        _lbTotalTime.textAlignment = NSTextAlignmentRight;
        [_lbTotalTime setText:@"00:00:00"];
        [_totalTimeView addSubview:_lbTotalTime];
    }
    return _totalTimeView;
}

- (UIView *) viewOfPace {
    if (!_paceView) {
        _paceView = [[UIView alloc] initWithFrame:CGRectMake(160, 70, 160, 70)]; // Right Middle
//        _paceView.layer.borderWidth = 1.0;
//        _paceView.layer.borderColor = [UIColor grayColor].CGColor;

        UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
        cellIcon.image = [UIImage imageNamed:@"icon-pace"];
        [_paceView addSubview:cellIcon];
        
        UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(111, 24, 40, 30)];
        unit.font = [UIFont fontWithName:@"DINCond-Medium" size:12.0];
        unit.textAlignment = NSTextAlignmentLeft;
        unit.text = @"/公里";
        [_paceView addSubview:unit];
        
        _lbPace = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 60, 30)];
        _lbPace.font = [UIFont fontWithName:@"DINPro-Medium" size:28.0];
        _lbPace.textColor = [UIColor blackColor];
        _lbPace.shadowColor = [UIColor whiteColor];
        _lbPace.shadowOffset = CGSizeMake(1, 1);
        _lbPace.textAlignment = NSTextAlignmentRight;
        [_lbPace setText:@"--"];
        [_paceView addSubview:_lbPace];
    }
    return _paceView;
}

- (UIView *) viewOfBpm {
    if (!_bmpView) {
        _bmpView = [[UIView alloc] initWithFrame:CGRectMake(160, 140, 160, 70)]; // Right Bottom
//        _bmpView.layer.borderWidth = 1.0;
//        _bmpView.layer.borderColor = [UIColor grayColor].CGColor;
        
        UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 20, 20)];
        cellIcon.image = [UIImage imageNamed:@"icon-bpm"];
        [_bmpView addSubview:cellIcon];
        
        UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(111, 24, 40, 30)];
        unit.font = [UIFont fontWithName:@"DINCond-Medium" size:12.0];
        unit.textAlignment = NSTextAlignmentLeft;
        unit.text = @"每分钟";
        [_bmpView addSubview:unit];
        
        _lbBpm = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 60, 30)];
        _lbBpm.font = [UIFont fontWithName:@"DINPro-Medium" size:28.0];
        _lbBpm.textColor = [UIColor blackColor];
        _lbBpm.shadowColor = [UIColor whiteColor];
        _lbBpm.shadowOffset = CGSizeMake(1, 1);
        _lbBpm.textAlignment = NSTextAlignmentRight;
        [_lbBpm setText:@"--"];
        [_bmpView addSubview:_lbBpm];
    }
    return _bmpView;
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
    
    [_lbDistance setText:[NSString stringWithFormat:@"%0.2f", [self.coords distanceM] / 1000]];
    
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

-(void)loadByUUID:(NSUUID *)uuid {
    _uuid = uuid;
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
    NSString *distance = [NSString stringWithFormat:@"%0.2f", distanceM / 1000];
    [_lbDistance setText:distance];
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
    self.mapView.frame = CGRectMake(0, 210, 320, self.view.bounds.size.height - 210);
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
    NSLog(@"准备心率计");
    UserVars *userVars = [UserVars sharedInstance];
    self.myPeripheral = userVars.peripheral;
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    _lbBpm.hidden = !tracker;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.myPeripheral.delegate = nil;
    self.manager.delegate = nil;
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
        self.lbUpdatingLocation = [[UILabel alloc] initWithFrame:CGRectZero];
        timer = [NSDate date];
        tracker = NO;
        
        locationManager = [[CLLocationManager alloc] init];

        self.myPeripheral = nil;
        
        [self initMapView];
        [self initInfos];
//        [self initUpdatingLocation];
    }
    return self;
}

- (void)prepareTrace {
    NSLog(@"wtvc prepareing trace ...");
//    self.title = @"准备中 ...";

    // 8.0及以上版本需要这段代码才能获取GPS坐标
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        [locationManager requestAlwaysAuthorization]; // 在后台也能拿到
        [locationManager startUpdatingLocation];
    }

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
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self onMapView];
    [self initButtons];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIColor *)colorWithSpeed:(double)speed {
    int index = (int)speed / -2;
    if (index > 5) index = 5;
//    NSLog(@"colorWithSpeed: %i", index);
    return [colorTable objectAtIndex:index];
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 10.f;
//        polylineView.strokeColor = [UIColor colorWithRed:.2 green:.1 blue:1 alpha:.8];

//        NSLog(@"mapView viewForOverlay speedColor: %0.0f", speedColor);
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
                NSLog(@"coord: [%0.9f] [%0.9f]", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
                Coord *coord = [[Coord alloc] init];
                [coord setCoordinateWithLat:userLocation.coordinate.latitude andLong:userLocation.coordinate.longitude];
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





//扫描
-(void)scanClick
{
    NSLog(@"正在扫描外设 ...");
    //[_activity startAnimating];
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.manager stopScan];
    });
}

//连接

-(void)connectClick:(id)sender
{
}


//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"蓝牙关闭。");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"蓝牙已准备就绪");
        [self scanClick];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"蓝牙状态无法认证");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"蓝牙状态未知");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"设备不支持蓝牙");
    }
}

//查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    self.myPeripheral = peripheral;
    [self.manager connectPeripheral:self.myPeripheral options:nil];
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {

//    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@", peripheral.name, [peripheral.identifier UUIDString]]);
//    NSLog(@"%@", [NSString stringWithFormat:@"myPeripheral: %@ with UUID: %@", self.myPeripheral.name, [self.myPeripheral.identifier UUIDString]]);
    if ([[peripheral.identifier UUIDString] isEqualToString:[self.myPeripheral.identifier UUIDString]]) {
        NSLog(@"找到了: %@", peripheral.name);
        [self.manager stopScan];
        [peripheral setDelegate:self];
        [peripheral discoverServices:nil];
    } else {
        NSLog(@"不是这个，继续找 ...");
    }
//    [self.manager stopScan];
    
    
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
}
//已发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//已搜索到Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_HEART_RATE_SERVICE_UUID]])  {  // 1
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Request heart rate notifications
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MEASUREMENT_CHARACTERISTIC_UUID]]) { // 2
                [self.myPeripheral setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found heart rate measurement characteristic");
            }
            // Request body sensor location
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID]]) { // 3
                [self.myPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found body sensor location characteristic");
            }
        }
    }
    // Retrieve Device Information Services for the Manufacturer Name
    if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID]])  { // 4
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {
                [self.myPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a device manufacturer name characteristic");
            }
        }
    }
}

/*
 Update UI with heart rate data received from device
 */
- (int) updateWithHRMData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0)
    {
        /* uint8 bpm */
        bpm = reportData[1];
    }
    else
    {
        /* uint16 bpm */
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }
    
    //    NSLog(@"updateWithHRMData: %i", bpm);
    return (int)bpm;
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Updated value for heart rate measurement received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MEASUREMENT_CHARACTERISTIC_UUID]]) { // 1
        // Get the Heart Rate Monitor BPM
        //                NSLog(@"got characteristic.value: %@", characteristic.value);
        int hrm = [self updateWithHRMData:characteristic.value];
        NSLog(@"%@: %d", peripheral.name, hrm);
        _lbBpm.text = [NSString stringWithFormat:@"%d", hrm];
    }
    // Retrieve the characteristic value for manufacturer name received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {  // 2
        //        [self getManufacturerName:characteristic];
    }
    // Retrieve the characteristic value for the body sensor location received
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID]]) {  // 3
        //        [self getBodyLocation:characteristic];
    }
    
    // Add your constructed device information to your UITextView
    //    self.deviceInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@\n", self.connected, self.bodyData, self.manufacturer];  // 4
}

@end
