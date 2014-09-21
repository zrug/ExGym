//
//  SettingsViewController.h
//  ExGym
//
//  Created by zrug on 14-9-20.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SettingsViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,
    UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
        int selectedRow;
}


@property BOOL cbReady;
@property BOOL isRefreshing;
@property(nonatomic) float batteryValue;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;

@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *nServices;
@property (strong,nonatomic) NSMutableArray *nCharacteristics;
@property (nonatomic,strong) UIButton *connect;
@property (nonatomic,strong) UIButton *scan;
@property (nonatomic,strong) UILabel *bpmtest;
@property (nonatomic,strong) UITableView *deviceTable;
@property (nonatomic,strong) UIActivityIndicatorView *activity;

@end
