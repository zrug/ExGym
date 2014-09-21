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
    imageView.image = [UIImage imageNamed:@"loginImage.jpg"];
    [self.view addSubview:imageView];
    
    [self.view addSubview:[self makeCoverView]];
}

- (UIView *)makeCoverView {
    if (coverView == nil) {
    
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsHeight - 230, 320, 230)];
        //    coverView.backgroundColor = [UIColor purpleColor];
        
        UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        userInfoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [coverView addSubview:userInfoView];
        
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 150)];
        menuView.backgroundColor = [UIColor colorWithRed:37/255. green:217/255. blue:235/255. alpha:1];
        [coverView addSubview:menuView];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(15, 20, 90, 50);
        btn2.frame = CGRectMake(115, 20, 90, 50);
        btn3.frame = CGRectMake(215, 20, 90, 50);
        btn4.frame = CGRectMake(15, 80, 90, 50);
        btn5.frame = CGRectMake(115, 80, 90, 50);
        btn6.frame = CGRectMake(215, 80, 90, 50);
        btn1.titleLabel.font = [UIFont systemFontOfSize:20];
        btn2.titleLabel.font = [UIFont systemFontOfSize:20];
        btn3.titleLabel.font = [UIFont systemFontOfSize:20];
        btn4.titleLabel.font = [UIFont systemFontOfSize:20];
        btn5.titleLabel.font = [UIFont systemFontOfSize:20];
        btn6.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn1 setTitle:@"我的" forState:UIControlStateNormal];
        [btn2 setTitle:@"运动" forState:UIControlStateNormal];
        [btn3 setTitle:@"附近" forState:UIControlStateNormal];
        [btn4 setTitle:@"预约" forState:UIControlStateNormal];
        [btn5 setTitle:@"消课" forState:UIControlStateNormal];
        [btn6 setTitle:@"设置" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
