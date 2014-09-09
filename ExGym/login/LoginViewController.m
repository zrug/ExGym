//
//  ViewController.m
//  ExGym
//
//  Created by zrug on 14-8-30.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoGatherViewController.h"

@interface LoginViewController () {
    float boundsHeight;

    BOOL inAnimation;
}

@end

@implementation LoginViewController

- (id)init {
    self = [super init];
    if (self) {
        fieldsOpen = false;
        inAnimation = false;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSLog(@"screen: w %0.0f h %0.0f", self.view.bounds.size.width, self.view.bounds.size.height);
    boundsHeight = self.view.bounds.size.height;
    // 568, 480
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (568 - boundsHeight) / -2, 320, 420)];
    imageView.image = [UIImage imageNamed:@"loginImage.jpg"];
    [self.view addSubview:imageView];

    [self.view addSubview:[self makeFieldView]];
    
    [self.view addSubview:[self makeCoverView]];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fieldOpen)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fieldClose)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)makeCoverView {
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsHeight - 230, 320, 230)];
    //    coverView.backgroundColor = [UIColor purpleColor];

    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    logoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [coverView addSubview:logoView];

    UIView *calendarView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 150)];
    calendarView.backgroundColor = [UIColor colorWithRed:37/255. green:217/255. blue:235/255. alpha:1];
    [coverView addSubview:calendarView];

    UILabel *sloganEn = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 150, 20)];
    sloganEn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    sloganEn.text = @"Leisurely life, exGym!";
    sloganEn.textColor = [UIColor whiteColor];
    sloganEn.font = [UIFont systemFontOfSize:13];
    sloganEn.textAlignment = NSTextAlignmentRight;
    [logoView addSubview:sloganEn];
    
    UILabel *sloganCn = [[UILabel alloc] initWithFrame:CGRectMake(160, 52, 150, 20)];
    sloganCn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    sloganCn.text = @"慢生活, 快健身!";
    sloganCn.textColor = [UIColor whiteColor];
    sloganCn.font = [UIFont systemFontOfSize:13];
    sloganCn.textAlignment = NSTextAlignmentRight;
    [logoView addSubview:sloganCn];

    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateCompoments = [calendar components:(
            NSDayCalendarUnit | NSWeekdayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    UILabel *calendarDay = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 180, 140)];
    calendarDay.font = [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:140];
    calendarDay.textColor = [UIColor whiteColor];
    calendarDay.text = [NSString stringWithFormat:@"%d", 28]; //[dateCompoments day]];
    calendarDay.textAlignment = NSTextAlignmentRight;
    [calendarView addSubview:calendarDay];
    
    UILabel *calendarMonth = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 30)];
    calendarMonth.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:20];
    calendarMonth.textColor = [UIColor whiteColor];
    calendarMonth.textAlignment = NSTextAlignmentLeft;
    dateFormatter.dateFormat = @"MMMM";
    calendarMonth.text = [[dateFormatter stringFromDate:today] capitalizedString];
    [calendarView addSubview:calendarMonth];
    
    UILabel *calendarYear = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 120, 30)];
    calendarYear.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:20];
    calendarYear.textColor = [UIColor whiteColor];
    calendarYear.text = [NSString stringWithFormat:@"%ld", [dateCompoments year]];
    calendarYear.textAlignment = NSTextAlignmentLeft;
    [calendarView addSubview:calendarYear];

    UILabel *calendarWeekday = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 120, 30)];
    calendarWeekday.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:20];
    calendarWeekday.textColor = [UIColor whiteColor];
    calendarWeekday.textAlignment = NSTextAlignmentLeft;
    dateFormatter.dateFormat=@"EEEE";
    calendarWeekday.text = [[dateFormatter stringFromDate:today] capitalizedString];
    [calendarView addSubview:calendarWeekday];

    return coverView;
}
- (UIView *)makeFieldView {
    fieldsView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsHeight - 140, 320, 140)];
    fieldsView.backgroundColor = [UIColor whiteColor];

    NSString* fontName = @"HelveticaNeue-UltraLight";
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, 200, 40)];
    username.font = [UIFont fontWithName:fontName size:16.0f];
    username.borderStyle = UITextBorderStyleRoundedRect;
    username.keyboardType = UIKeyboardTypeEmailAddress;
    username.delegate = self;
    [fieldsView addSubview:username];

    password = [[UITextField alloc] initWithFrame:CGRectMake(15, 65, 200, 40)];
    password.font = [UIFont fontWithName:fontName size:16.0f];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.keyboardType = UIKeyboardTypeASCIICapable;
    password.delegate = self;
    [fieldsView addSubview:password];
    
    doLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doLogin.frame = CGRectMake(230, 15, 75, 90);
    doLogin.titleLabel.text = @"登录";
    doLogin.backgroundColor = [UIColor purpleColor];
    [doLogin addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [fieldsView addSubview:doLogin];
    
    return fieldsView;
}

- (void)loginEvent:(id)sender {
    inAnimation = !inAnimation;

    [username resignFirstResponder];
    [password resignFirstResponder];
    
    CGSize size = self.view.frame.size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, 0, size.width, size.height);
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
        CGRect frame = imageView.frame;
        frame.origin.y += 70;
        imageView.frame = frame;
        
        frame = coverView.frame;
        frame.origin.y += 140;
        coverView.frame = frame;
    } completion:^(BOOL finished) {
        fieldsOpen = !fieldsOpen;
        inAnimation = !inAnimation;
        NSLog(@"fieldCloseWithBlock, the block");
        UserInfoGatherViewController *userInfoGatherViewController = [[UserInfoGatherViewController alloc] initWithNibName:nil bundle:nil];
        userInfoGatherViewController.navigationController.title = @"完善个人信息";
        [self.navigationController pushViewController:userInfoGatherViewController animated:YES];
    }];

}

- (void)fieldOpen {
    if (!fieldsOpen && !inAnimation) {
        inAnimation = !inAnimation;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
            CGRect frame = imageView.frame;
            frame.origin.y -= 70;
            imageView.frame = frame;

            frame = coverView.frame;
            frame.origin.y -= 140;
            coverView.frame = frame;
        } completion:^(BOOL finished) {
            fieldsOpen = !fieldsOpen;
            inAnimation = !inAnimation;
        }];
    }
}
- (void)fieldClose {
    if (fieldsOpen && !inAnimation) {
        inAnimation = !inAnimation;
        if ([username isFirstResponder] || [password isFirstResponder]) {
            
            [self textFieldShouldReturn:password];
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
            CGRect frame = imageView.frame;
            frame.origin.y += 70;
            imageView.frame = frame;
            
            frame = coverView.frame;
            frame.origin.y += 140;
            coverView.frame = frame;
        } completion:^(BOOL finished) {
            fieldsOpen = !fieldsOpen;
            inAnimation = !inAnimation;
        }];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"textField top: %0.0f", textField.frame.origin.y);
    if (textField == username || textField == password) {
        CGSize size = self.view.frame.size;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, -160 - textField.frame.origin.y, size.width, size.height);
        [UIView commitAnimations];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [username resignFirstResponder];
    [password resignFirstResponder];
    if (textField == username) {
        [password becomeFirstResponder];
    } else {
        CGSize size = self.view.frame.size;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, 0, size.width, size.height);
        [UIView commitAnimations];
    }
    return YES;
}

@end
