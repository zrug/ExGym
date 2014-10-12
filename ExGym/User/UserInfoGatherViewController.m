//
//  UserInfoGatherViewController.m
//  ExGym
//
//  Created by zrug on 14-9-9.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "UserInfoGatherViewController.h"
#import "ActionSheetPicker.h"

@interface UserInfoGatherViewController ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) UITextField *realName;
@property (nonatomic, retain) UITextField *cellphone;

@property (nonatomic, retain) ActionSheetStringPicker *genderPicker;
@property (nonatomic, retain) ActionSheetStringPicker *heightPicker;
@property (nonatomic, retain) ActionSheetStringPicker *weightPicker;
@property (nonatomic, retain) ActionSheetStringPicker *beatTopPicker;
@property (nonatomic, retain) ActionSheetDatePicker *birthdayPicker;

@end

@implementation UserInfoGatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UITextField *)cellFieldWithPlaceholder:(NSString *)placeholder andKeyboardType:(UIKeyboardType)keyboardType {
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0,10,125,25)];
    textfield.adjustsFontSizeToFitWidth = NO;
    textfield.backgroundColor = [UIColor clearColor];
    textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textfield.textAlignment = NSTextAlignmentRight;
    textfield.keyboardType = keyboardType;
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.clearButtonMode = UITextFieldViewModeNever;
    textfield.placeholder = placeholder;
    textfield.delegate = self;
    return textfield;
}

-(void)timeWasSelected:(NSDate *)selectedTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy - M - d"];
    NSLog(@"%@", [dateFormatter stringFromDate:selectedTime]);
    UITableViewCell *cell = [_cells objectAtIndex:3];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:selectedTime];
}

-(void)genderWasSelectedIndex:(NSInteger *)index String:(NSString *)string{
    NSLog(@"%@", string);
}

-(void)genderWasCanceled {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"me is in!");

    _birthdayPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"您的出生年月" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(timeWasSelected:) origin:self.view];
    [_birthdayPicker setLocale:[NSLocale currentLocale]];
    [_birthdayPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [_birthdayPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    NSArray *genderValues = [NSArray arrayWithObjects:@"男", @"女", nil];
    _genderPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"您的性别" rows:genderValues initialSelection:0
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             NSLog(@"Selected gender Value: %@", selectedValue);
                                                             UITableViewCell *cell = [_cells objectAtIndex:2];
                                                             cell.detailTextLabel.text = selectedValue;
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           NSLog(@"Block Picker Canceled");
                                                       }
                                                            origin:self.view];
    [_genderPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [_genderPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];

    NSMutableArray* heightValues = [[NSMutableArray alloc] initWithCapacity:130];
    for (int i=120; i<250; i++)
        [heightValues addObject:[NSString stringWithFormat:@"%d cm", i]];
    _heightPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"您的身高" rows:heightValues initialSelection:50
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             NSLog(@"Selected height Value: %@", selectedValue);
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           NSLog(@"Block Picker Canceled");
                                                       }
                                                            origin:self.view];
    [_heightPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [_heightPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    NSMutableArray* weightValues = [[NSMutableArray alloc] initWithCapacity:90];
    for (int i=30; i<120; i++)
        [weightValues addObject:[NSString stringWithFormat:@"%d kg", i]];
    _weightPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"您的身高" rows:weightValues initialSelection:30
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             NSLog(@"Selected height Value: %@", selectedValue);
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           NSLog(@"Block Picker Canceled");
                                                       }
                                                            origin:self.view];
    [_weightPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [_weightPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    NSMutableArray* beatTopValues = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i=120; i<220; i++)
        [beatTopValues addObject:[NSString stringWithFormat:@"%d", i]];
    _beatTopPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"您的最高心率" rows:beatTopValues initialSelection:80
                                                         doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                             NSLog(@"Selected height Value: %@", selectedValue);
                                                         }
                                                       cancelBlock:^(ActionSheetStringPicker *picker) {
                                                           NSLog(@"Block Picker Canceled");
                                                       }
                                                            origin:self.view];
    [_beatTopPicker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [_beatTopPicker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    
    
    
    _cells = [[NSMutableArray alloc] initWithCapacity:6];
    UITableViewCell *cell;
    
    _realName = [self cellFieldWithPlaceholder:@"真实姓名" andKeyboardType:UIKeyboardTypeDefault];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"";
    UIButton *userAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
    userAvatar.frame = CGRectMake(30, 30, 60, 60);
    [userAvatar setImage:[UIImage imageNamed:@"user-guest.png"] forState:UIControlStateNormal];
    [cell addSubview:userAvatar];
    cell.accessoryView = _realName;
    [_cells addObject:cell];
    
    _cellphone = [self cellFieldWithPlaceholder:@"电话号码" andKeyboardType:UIKeyboardTypeASCIICapable];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"联系方式";
    cell.accessoryView = _cellphone;
    [_cells addObject:cell];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"性别";
    cell.detailTextLabel.text = @"男";
    [_cells addObject:cell];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"出生年月";
    cell.detailTextLabel.text = @"1979 - 6 - 12";
    [_cells addObject:cell];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"身高";
    cell.detailTextLabel.text = @"182 cm";
    [_cells addObject:cell];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"体重";
    cell.detailTextLabel.text = @"80 kg";
    [_cells addObject:cell];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"最大心率";
    cell.detailTextLabel.text = @"190";
    [_cells addObject:cell];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 538)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightButtonClickEvent:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"My Title";
    [self.navigationItem setTitleView:titleLabel];
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightButtonClickEvent:(id)sender {
    NSLog(@"me is done!");
}



#pragma mark - tableView delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 120;
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cells objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 2:
            [_genderPicker showActionSheetPicker];
            break;
        case 3:
            [_birthdayPicker showActionSheetPicker];
            break;
        case 4:
            [_heightPicker showActionSheetPicker];
            break;
        case 5:
            [_weightPicker showActionSheetPicker];
            break;
        case 6:
            [_beatTopPicker showActionSheetPicker];
            break;
            
    }
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
