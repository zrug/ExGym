//
//  UIButton+UIImage.m
//  ExGym
//
//  Created by zrug on 14-10-7.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "UIButton+UIImage.h"

@implementation UIButton(Image)

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title andImage:(UIImage *)image {
    self = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (self) {
        self.frame = frame;
        UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 26, 26)];
        btnImageView.image = image;
        [self addSubview:btnImageView];
        UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 10, 55, 30)];
        btnLabel.text = title;
        btnLabel.font = [UIFont systemFontOfSize:18];
        btnLabel.textColor = [UIColor whiteColor];
        [self addSubview:btnLabel];
    }
    return self;
}


@end
