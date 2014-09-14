//
//  NavWalkoutViewController.m
//  officialDemo2D
//
//  Created by Zrug on 13-12-19.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import "NavWalkoutViewController.h"
#import "WalkingTraceViewController.h"
#import "Coords.h"
#import "DataFile.h"
#import "Coord.h"

@interface NavWalkoutViewController () {
    NSMutableArray *cells;
    DataFile *dataFile;
}
@property (nonatomic, strong) WalkingTraceViewController *wtvc;

@property (nonatomic, copy) NSString *str;
@property (nonatomic, strong) UIBarButtonItem *addtrace;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end

@implementation NavWalkoutViewController

@synthesize addtrace = _addtrace;
@synthesize tableView = _tableView;
@synthesize wtvc = _wtvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        self.addtrace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTrace)];
        self.navigationItem.rightBarButtonItem = self.addtrace;

        self.wtvc = [[WalkingTraceViewController alloc] initWithNibName:@"WalkingTraceViewController" bundle:nil];
        [self.wtvc prepareTrace];
    }
    return self;
}

- (IBAction)addNewTrace {
    [self.wtvc startTrace];
    [self.navigationController pushViewController:self.wtvc animated:YES];
}

- (NSMutableArray *)cellsInstance {
    NSMutableArray *allCoords = [[NSMutableArray alloc] init];
    NSMutableArray *_cells = [[NSMutableArray alloc] init];
    dataFile = [[DataFile alloc] initData];
    
    if ([dataFile.data count] > 0) {
        Coords *coords;
        for (NSDictionary *obj in dataFile.data) {
            coords = [[Coords alloc] initWithData:obj];
            [allCoords addObject:coords];
        }

        UITableViewCell *_cell;
        for (int i=[allCoords count]-1; i>=0; i--) {
            _cell = [self cellInstanceWithCoords:[allCoords objectAtIndex:i]];
            [_cells addObject:_cell];
        }
    }
    return _cells;
}
- (UITableViewCell *)cellInstance {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellReuseIdentifier"];
    cell.textLabel.text = @"OOPS";
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"detail";
    return cell;
}
- (UITableViewCell *)cellInstanceWithCoords:(Coords *)coords {
    UITableViewCell *_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellReuseIdentifier"];

    _cell.textLabel.text = [NSString stringWithFormat:@"距离: %0.0f米", [coords distanceM]];
    _cell.detailTextLabel.text = [coords description];
    
    _cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return _cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    cells = [self cellsInstance];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [cells objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Coords *coords = [dataFile coordsWithIndex:[dataFile.data count] - 1 - indexPath.row];
    NSLog(@"didSelectRowAtIndexPath coords.count: %d", [[coords overlays] count]);
    [self.wtvc load:coords];
    
    [self.navigationController pushViewController:self.wtvc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DataFile removeAtLast:indexPath.row];
        [cells removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}


@end
