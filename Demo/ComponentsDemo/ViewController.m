//
//  ViewController.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/7/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "ViewController.h"

@implementation MenuItem

@synthesize className;
@synthesize categoryName;

+ (id) itemWithClassName:(NSString *)aClassName
{
    return [[[self alloc] initWithClassName:aClassName] autorelease];
}

+ (id) itemWithClassName:(NSString *)aClassName categoryName:(NSString *)aCategoryName
{
    return [[[self alloc] initWithClassName:aClassName categoryName:aCategoryName] autorelease];
}

- (id) initWithClassName:(NSString *)aClassName
{
    return [self initWithClassName:aClassName categoryName:nil];
}

- (id) initWithClassName:(NSString *)aClassName categoryName:(NSString *)aCategoryName
{
    if ((self = [super init])) {
        self.className = aClassName;
        self.categoryName = aCategoryName;
    }
    return self;
}

- (void) dealloc
{
    self.className = nil;
    self.categoryName = nil;

    [super dealloc];
}

- (NSString *) viewControllerClassName
{
    if (!categoryName) {
        return [NSString stringWithFormat:@"VC_%@", className];
    } else {
        return [NSString stringWithFormat:@"VC_%@_%@", className, categoryName];
    }
}

- (NSString *) title
{
    if (!categoryName) {
        return className;
    } else {
        return [NSString stringWithFormat:@"%@+%@", className, categoryName];
    }
}

@end

@implementation ViewController

@synthesize menu;

- (void) dealloc
{
    self.menu = nil;

    [super dealloc];
}

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
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSEditEnder"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSProgressDownloader"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSSheetView"]];

    NSMutableArray *menuCategories = [[NSMutableArray alloc] init];
    [menuCategories addObject:[MenuItem itemWithClassName:@"MKMapView" categoryName:@"Zoom"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSMutableArray" categoryName:@"Shuffling"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSString" categoryName:@"DateConversion"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSString" categoryName:@"Digest"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSTimer" categoryName:@"Pause"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"UIAcceleration" categoryName:@"DeviceAngle"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"UIBarButtonItem" categoryName:@"CustomImage"]];

    self.menu = [NSMutableArray arrayWithObjects:menuClasses, menuCategories, nil];
    [menuClasses release];
    [menuCategories release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.menu = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [menu count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Classes";
    } else {
        return @"Categories";
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[menu objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:identifier] autorelease];
    }

    MenuItem *item = [[menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    cell.textLabel.text = item.className;
    if (item.categoryName) {
        cell.detailTextLabel.text = item.categoryName;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = [[menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    UIViewController *vc = [[NSClassFromString([item viewControllerClassName]) alloc] init];
    vc.title = [item title];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
