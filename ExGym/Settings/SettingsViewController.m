//
//  SettingsViewController.m
//  ExGym
//
//  Created by zrug on 14-9-20.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"
#import <CoreBluetooth/CoreBluetooth.h>

#ifndef BluetoothTest_config_h
#define BluetoothTest_config_h

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

#define DEVICE_NAME_UUID 0x2A00
#define BATTERT_LEVEL_UUID 0x2A19
#define ALERT_LEVEL_UUID 0x2a06

#define ALERT_VALUE_ON 0x01
#define ALERT_VALUE_OFF 0x00

#define POLARH7_HRM_DEVICE_INFO_SERVICE_UUID @"180A"
#define POLARH7_HRM_HEART_RATE_SERVICE_UUID @"180D"

#define POLARH7_HRM_MEASUREMENT_CHARACTERISTIC_UUID @"2A37"
#define POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID @"2A38"
#define POLARH7_HRM_MANUFACTURER_NAME_CHARACTERISTIC_UUID @"2A29"

#endif


@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedRow = -1;
    
    if (IOS7) {
        self.view.bounds  = CGRectMake(0, -64, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    _scan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_scan setTitle:@"扫描" forState:UIControlStateNormal];
    _scan.frame = CGRectMake(20, 210, 60, 30);
    [_scan addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    [_scan setEnabled:NO];
    [self.view addSubview:_scan];
    
    _connect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_connect setTitle:@"连接" forState:UIControlStateNormal];
    _connect.frame = CGRectMake(90, 210, 60, 30);
    [_connect addTarget:self action:@selector(connectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connect];
    
    _bpmtest = [[UILabel alloc] initWithFrame:CGRectMake(160, 210, 160, 30)];
    [_bpmtest setFont:[UIFont fontWithName:@"DINCondensed-Bold" size:14]];
    _bpmtest.text = @"未连接";
    _bpmtest.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_bpmtest];
    
    _cbReady = false;
    _nDevices = [[NSMutableArray alloc]init];
    _nServices = [[NSMutableArray alloc]init];
    _nCharacteristics = [[NSMutableArray alloc]init];
    
    _deviceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 190) style:UITableViewStyleGrouped];
    _deviceTable.delegate = self;
    _deviceTable.dataSource = self;
    [self.view addSubview:_deviceTable];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"clear settings shit");
    self.peripheral.delegate = nil;
    [self.manager stopScan];
    self.manager.delegate = nil;
}



#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nDevices count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identified = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identified];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identified];
    }
    CBPeripheral *p = [_nDevices objectAtIndex:indexPath.row];
    cell.textLabel.text = p.name;
    cell.textLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:24];
    if (_cbReady && indexPath.row == selectedRow)
        cell.detailTextLabel.text = @"已连接";
    else
        cell.detailTextLabel.text = @"";
    
    //cell.textLabel.text = [_nDevices objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"已扫描到的设备:";
}

//textView更新
-(void)updateLog:(NSString *)s
{
    _bpmtest.text = s;
}
//实现代理方法
-(void)selectCategary:(NSString *)name
{
    //_nameLabel.text = name;
}


//扫描
-(void)scanClick
{
    [_scan setEnabled:NO];
    NSLog(@"正在扫描外设 ...");
    [self updateLog:@"扫描中..."];
    //[_activity startAnimating];
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.manager stopScan];
        [_activity stopAnimating];
        [self updateLog:@"扫描结束"];
        [_scan setEnabled:YES];
    });
}

//连接

-(void)connectClick:(id)sender
{
    if (selectedRow >= 0) {
        _peripheral = [_nDevices objectAtIndex:selectedRow];
        if (_cbReady ==false) {
            [self.manager connectPeripheral:_peripheral options:nil];
            _cbReady = true;
            [_connect setTitle:@"断开" forState:UIControlStateNormal];
            [_deviceTable setUserInteractionEnabled:NO];
        }else {
            [self.manager cancelPeripheralConnection:_peripheral];
            _cbReady = false;
            [_connect setTitle:@"连接" forState:UIControlStateNormal];
            [_deviceTable setUserInteractionEnabled:YES];
            [self updateLog:@"已断开"];
        }
        [_deviceTable reloadData];
    } else {
        
        NSLog(@"select a device");
    }
    
}

//报警
-(void)sendClick:(UIButton *)bu
{
    unsigned char data = 0x02;
    [_peripheral writeValue:[NSData dataWithBytes:&data length:1] forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"蓝牙关闭。");
        [self updateLog:@"蓝牙关闭"];
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"蓝牙已准备就绪");
        [self updateLog:@"已准备就绪"];
        [self scanClick];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"蓝牙状态无法认证");
        [self updateLog:@"蓝牙无法认证"];
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"蓝牙状态未知");
        [self updateLog:@"蓝牙状态未知"];
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"设备不支持蓝牙");
        [self updateLog:@"不支持蓝牙"];
    }
}

//查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    BOOL replace = NO;
    // Match if we have this device from before
    for (int i=0; i < _nDevices.count; i++) {
        CBPeripheral *p = [_nDevices objectAtIndex:i];
        if ([p isEqual:peripheral]) {
            [_nDevices replaceObjectAtIndex:i withObject:peripheral];
            replace = YES;
        }
    }
    if (!replace) {
        [_nDevices addObject:peripheral];
        [_deviceTable reloadData];
    }
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@", peripheral.name, [peripheral.identifier UUIDString]]);
    
    UserVars *uservar = [UserVars sharedInstance];
    uservar.peripheral = _peripheral;
    
    [_peripheral setDelegate:self];
    [_peripheral discoverServices:nil];
    [self updateLog:@"连接成功,扫描服务"];
    
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
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
                [self updateLog:@"发现心率计"];
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
    @try {
        if ((reportData[0] & 0x01) == 0)
        {
            NSLog(@"uint8 bpm %@", data);
            /* uint8 bpm */
            bpm = reportData[1];
        }
        else
        {
            NSLog(@"uint16 bpm %@", data);
            /* uint16 bpm */
            bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
        }

    }
    @catch (NSException *exception) {
        NSLog(@"ERROR: convert updateWithHRMData data to uint failed");
    }
    @finally {
        
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
        [self updateLog:[NSString stringWithFormat:@"测试心率：%d", hrm]];
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
//将视频保存到目录文件夹下
-(BOOL)saveToDocument:(NSData *) data withFilePath:(NSString *) filePath
{
    if ((data == nil) || (filePath == nil) || [filePath isEqualToString:@""]) {
        return NO;
    }
    @try {
        //将视频写入指定路径
        [data writeToFile:filePath atomically:YES];
        return  YES;
    }
    @catch (NSException *exception) {
        NSLog(@"保存失败");
    }
    return NO;
}

//根据当前时间将视频保存到VideoFile文件夹中
-(NSString *)imageSavedPath:(NSString *) VideoName
{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指定新建文件夹路径
    NSString *videoDocPath = [documentPath stringByAppendingPathComponent:@"VideoFile"];
    //创建VideoFile文件夹
    [fileManager createDirectoryAtPath:videoDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //返回保存图片的路径（图片保存在VideoFile文件夹下）
    NSString * VideoPath = [videoDocPath stringByAppendingPathComponent:VideoName];
    return VideoPath;
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)
    characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
}
//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
