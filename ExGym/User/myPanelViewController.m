//
//  MyPanelViewController.m
//  ExGym
//
//  Created by zrug on 14-9-13.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "MyPanelViewController.h"
#import "UserInfoGatherViewController.h"
#import "NavWalkoutViewController.h"
#import "SettingsViewController.h"
#import "UIButton+UIImage.h"

@interface MyPanelViewController () {
    float boundsHeight;
}

@end

@implementation MyPanelViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    boundsHeight = self.view.bounds.size.height;
    // 568, 480
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (568 - boundsHeight) / -2, 320, 420)];
    imageView.image = [UIImage imageNamed:@"1770133_2091.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    [self.view addSubview:[self makeCoverView]];
}

- (UIView *)makeCoverView {
    if (coverView == nil) {
    
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsHeight - 212, 320, 212)];
        
        UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
        userInfoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [coverView addSubview:userInfoView];
        
        UIImageView *userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 52, 52)];
        userAvatar.image = [UIImage imageNamed:@"user-guest-white.png"];
        [userInfoView addSubview:userAvatar];
        
        UILabel *userNameCN = [[UILabel alloc] initWithFrame:CGRectMake(70, 14, 100, 20)];
        userNameCN.text = @"游客";
        userNameCN.textColor = [UIColor whiteColor];
        [userInfoView addSubview:userNameCN];
        UILabel *userNameEN = [[UILabel alloc] initWithFrame:CGRectMake(70, 34, 100, 20)];
        userNameEN.text = @"Guest";
        userNameEN.font = [UIFont systemFontOfSize:14];
        userNameEN.textColor = [UIColor whiteColor];
        [userInfoView addSubview:userNameEN];
        
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, 320, 150)];
        menuView.backgroundColor = [UIColor colorWithRed:37/255. green:217/255. blue:235/255. alpha:1];
        [coverView addSubview:menuView];
        
        
        //        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 90, 50) withTitle:@"我的"
                                                andImage:[UIImage imageNamed:@"mypanel-comfirmUser.png"]];
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(115, 20, 90, 50) withTitle:@"运动"
                                                andImage:[UIImage imageNamed:@"mypanel-sent.png"]];
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(215, 20, 90, 50) withTitle:@"附近"
                                                andImage:[UIImage imageNamed:@"mypanel-location.png"]];
        UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(15, 80, 90, 50) withTitle:@"预约"
                                                andImage:[UIImage imageNamed:@"mypanel-todos.png"]];
        UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(115, 80, 90, 50) withTitle:@"消课"
                                                andImage:[UIImage imageNamed:@"mypanel-memo.png"]];
        UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(215, 80, 90, 50) withTitle:@"设置"
                                                andImage:[UIImage imageNamed:@"mypanel-timer.png"]];

        [menuView addSubview:btn1];
        [menuView addSubview:btn2];
        [menuView addSubview:btn3];
        [menuView addSubview:btn4];
        [menuView addSubview:btn5];
        [menuView addSubview:btn6];

        [btn1 addTarget:self action:@selector(handleBtn1) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(handleBtn2) forControlEvents:UIControlEventTouchUpInside];
        [btn6 addTarget:self action:@selector(handleBtn6) forControlEvents:UIControlEventTouchUpInside];
    }

    return coverView;
}

- (void)handleBtn1 {
    UserInfoGatherViewController *userInfoGatherViewController = [[UserInfoGatherViewController alloc] initWithNibName:nil bundle:nil];
    userInfoGatherViewController.navigationController.title = @"完善个人信息";
    [self.navigationController pushViewController:userInfoGatherViewController animated:YES];
}

- (void)handleBtn2 {
    NavWalkoutViewController *walkout = [[NavWalkoutViewController alloc] initWithNibName:@"NavWalkoutViewController" bundle:nil];
    walkout.navigationController.title = @"步行记录";
    [self.navigationController pushViewController:walkout animated:YES];
}

- (void)handleBtn6 {
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    settings.navigationController.title = @"设置";
    [self.navigationController pushViewController:settings animated:YES];
    
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
