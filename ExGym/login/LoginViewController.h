//
//  ViewController.h
//  ExGym
//
//  Created by zrug on 14-8-30.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    UIImageView *imageView;
    UIView *coverView;
    UIView *fieldsView;
    
    UITextField *username;
    UITextField *password;
    UIButton *doLogin;
    
    BOOL fieldsOpen;
}


@end
