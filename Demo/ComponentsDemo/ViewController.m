//
//  ViewController.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/7/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "ViewController.h"

//#import "VC_KSAdvancedPicker.h"
//#import "VC_KSCheckView.h"
//#import "VC_KSEditEnder.h"
//#import "VC_KSProgressDownloader.h"
//#import "VC_KSSheetView.h"

@implementation ViewController

@synthesize menu;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menu = [NSMutableArray array];
    
    [menu addObject:@"KSAdvancedPicker"];
    [menu addObject:@"KSCheckView"];
    [menu addObject:@"KSEditEnder"];
    [menu addObject:@"KSProgressDownloader"];
    [menu addObject:@"KSSheetView"];
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
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menu count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier] autorelease];
    }
    
    cell.textLabel.text = [menu objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *menuName = [menu objectAtIndex:indexPath.row];
    NSString *vcName = [NSString stringWithFormat:@"VC_%@", menuName];
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
