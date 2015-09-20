//
//  ViewController.m
//  Components
//
//  Created by Davide De Rosa on 11/7/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import "ViewController.h"

@implementation MenuItem

+ (instancetype)itemWithClassName:(NSString *)className
{
    return [[self alloc] initWithClassName:className];
}

+ (instancetype)itemWithClassName:(NSString *)className categoryName:(NSString *)categoryName
{
    return [[self alloc] initWithClassName:className categoryName:categoryName];
}

- (instancetype)initWithClassName:(NSString *)className
{
    return [self initWithClassName:className categoryName:nil];
}

- (instancetype)initWithClassName:(NSString *)className categoryName:(NSString *)categoryName
{
    if ((self = [super init])) {
        self.className = className;
        self.categoryName = categoryName;
    }
    return self;
}

- (NSString *)viewControllerClassName
{
    if (!self.categoryName) {
        return [NSString stringWithFormat:@"VC_%@", self.className];
    } else {
        return [NSString stringWithFormat:@"VC_%@_%@", self.className, self.categoryName];
    }
}

- (NSString *)title
{
    if (!self.categoryName) {
        return self.className;
    } else {
        return [NSString stringWithFormat:@"%@+%@", self.className, self.categoryName];
    }
}

@end

#pragma mark -

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *menuClasses = [[NSMutableArray alloc] init];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSAdvancedPicker"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSCheckView"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSGridView"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSSheetView"]];

    NSMutableArray *menuCategories = [[NSMutableArray alloc] init];
    [menuCategories addObject:[MenuItem itemWithClassName:@"MKMapView" categoryName:@"Zoom"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSMutableArray" categoryName:@"Shuffling"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSString" categoryName:@"DateConversion"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSString" categoryName:@"Digest"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSString" categoryName:@"Random"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSTimer" categoryName:@"Pause"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"UIBarButtonItem" categoryName:@"CustomImage"]];

    self.menu = [NSArray arrayWithObjects:menuClasses, menuCategories, nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menu count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Classes";
    } else {
        return @"Categories";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.menu objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
    }

    MenuItem *item = self.menu[indexPath.section][indexPath.row];

    cell.textLabel.text = item.className;
    cell.detailTextLabel.text = item.categoryName; // may be nil

    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = self.menu[indexPath.section][indexPath.row];

    UIViewController *vc = [[NSClassFromString([item viewControllerClassName]) alloc] init];
    vc.title = [item title];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
