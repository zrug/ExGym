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
    NSLog(@"");
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
        
        self.peripheral = nil;
        
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
    
    UserVars *userVars = [UserVars sharedInstance];
    self.peripheral = userVars.peripheral;
    NSLog(@"已装备心率计: %@", self.peripheral.name);

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
    if (self.peripheral != nil) {
        NSLog(@"心率读取中 ...");
        self.peripheral.delegate = self;
    }
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





//扫描
-(void)scanClick
{
    NSLog(@"正在连接心率计 ...");
    //[_activity startAnimating];
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    double delayInSeconds = 30.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.manager stopScan];
        NSLog(@"连接超时！");
    });
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
    [_manager stopScan];
    NSLog(@"%@", [NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@", peripheral.name, RSSI, peripheral.UUID, advertisementData]);
    
    [_manager connectPeripheral:_peripheral options:nil];
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.UUID]);
    
    UserVars *uservar = [UserVars sharedInstance];
    uservar.peripheral = _peripheral;
    
    [_peripheral setDelegate:self];
    [_peripheral discoverServices:nil];
    
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    NSLog(@"发现BLT4.0热点, 距离：%@",length);
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
                [_peripheral setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found heart rate measurement characteristic");
            }
            // Request body sensor location
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID]]) { // 3
                [_peripheral readValueForCharacteristic:aChar];
                NSLog(@"Found body sensor location characteristic");
            }
        }
    }
    // Retrieve Device Information Services for the Manufacturer Name
    if ([service.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_DEVICE_INFO_SERVICE_UUID]])  { // 4
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {
                [_peripheral readValueForCharacteristic:aChar];
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
        NSLog(@"got characteristic.value");
        int hrm = [self updateWithHRMData:characteristic.value];
        NSLog(@"%@: %d", peripheral.name, hrm);
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
