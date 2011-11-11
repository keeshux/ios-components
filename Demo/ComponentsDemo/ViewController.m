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

@end

@implementation ViewController

@synthesize menuClasses;
@synthesize menuCategories;

- (void) dealloc
{
    self.menuClasses = nil;
    self.menuCategories = nil;

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
    
    self.menuClasses = [NSMutableArray array];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSAdvancedPicker"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSCheckView"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSEditEnder"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSProgressDownloader"]];
    [menuClasses addObject:[MenuItem itemWithClassName:@"KSSheetView"]];

    self.menuCategories = [NSMutableArray array];
    [menuCategories addObject:[MenuItem itemWithClassName:@"MKMapView" categoryName:@"Zoom"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"NSString" categoryName:@"DateConversion"]];
    [menuCategories addObject:[MenuItem itemWithClassName:@"UIBarButtonItem" categoryName:@"CustomImage"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.menuClasses = nil;
    self.menuCategories = nil;
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
    return 2;
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
    if (section == 0) {
        return [menuClasses count];
    } else {
        return [menuCategories count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:identifier] autorelease];
    }

    MenuItem *item = nil;
    if (indexPath.section == 0) {
        item = [menuClasses objectAtIndex:indexPath.row];
    } else {
        item = [menuCategories objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = item.className;
    if (item.categoryName) {
        cell.detailTextLabel.text = item.categoryName;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = nil;
    if (indexPath.section == 0) {
        item = [menuClasses objectAtIndex:indexPath.row];
    } else {
        item = [menuCategories objectAtIndex:indexPath.row];
    }

    NSString *vcName = nil;
    if (!item.categoryName) {
        vcName = [NSString stringWithFormat:@"VC_%@", item.className];
    } else {
        vcName = [NSString stringWithFormat:@"VC_%@_%@", item.className, item.categoryName];
    }

    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
