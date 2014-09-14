//
//  AddressComponentDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-26.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "AddressComponentDetailViewController.h"
#import "StreetNumberDetailViewController.h"

@interface AddressComponentDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddressComponentDetailViewController
@synthesize addressComponent = _addressComponent;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    switch (indexPath.row)
    {
        case 0: title = @"省";      break;
        case 1: title = @"市";      break;
        case 2: title = @"区";      break;
        case 3: title = @"乡镇";     break;
        case 4: title = @"社区";     break;
        case 5: title = @"建筑";     break;
        default:title = @"门牌信息";  break;
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    
    switch (indexPath.row)
    {
        case 0: subTitle = self.addressComponent.province;      break;
        case 1: subTitle = self.addressComponent.city;          break;
        case 2: subTitle = self.addressComponent.district;      break;
        case 3: subTitle = self.addressComponent.township;      break;
        case 4: subTitle = self.addressComponent.neighborhood;  break;
        case 5: subTitle = self.addressComponent.building;      break;
        default:subTitle = [self.addressComponent.streetNumber description]; break;
    }
    
    return subTitle;
}

- (void)gotoDetailForStreenNumber:(AMapStreetNumber *)streetNumber
{
    if (streetNumber != nil)
    {
        StreetNumberDetailViewController *streetNumberDetailViewController = [[StreetNumberDetailViewController alloc] init];
        
        streetNumberDetailViewController.streetNumber = streetNumber;
        
        [self.navigationController pushViewController:streetNumberDetailViewController animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6)
    {
        [self gotoDetailForStreenNumber:self.addressComponent.streetNumber];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addressComponentDetailCellIdentifier = @"addressComponentDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressComponentDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:addressComponentDetailCellIdentifier];
    }
    
    if (indexPath.row == 6)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTitle:@"地址组成要素 (AMapAddressComponent)"];
    
    [self initTableView];
}

@end
