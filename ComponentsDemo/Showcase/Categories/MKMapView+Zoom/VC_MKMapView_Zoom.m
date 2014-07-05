//
//  VC_MKMapView_Zoom.m
//  Components
//
//  Created by Davide De Rosa on 11/11/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_MKMapView_Zoom.h"
#import "KSBasicMapAnnotation.h"
#import "MKMapView+Zoom.h"

@implementation VC_MKMapView_Zoom

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:map];
    [map release];

    // add some annotations
    [map addAnnotation:[KSBasicMapAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(52.37022, 4.89517)
                                                                title:@"Amsterdam"
                                                             subtitle:@"Holland"]];
    [map addAnnotation:[KSBasicMapAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(52.52341, 13.41140)
                                                                title:@"Berlin"
                                                             subtitle:@"Germany"]];
    [map addAnnotation:[KSBasicMapAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(51.50015, -0.12624)
                                                                title:@"London"
                                                             subtitle:@"United Kingdom"]];
    [map addAnnotation:[KSBasicMapAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(48.85661, 2.35222)
                                                                title:@"Paris"
                                                             subtitle:@"France"]];
    [map addAnnotation:[KSBasicMapAnnotation annotationWithCoordinate:CLLocationCoordinate2DMake(41.89052, 12.49425)
                                                                title:@"Rome"
                                                             subtitle:@"Italy"]];

    // zoom on them
    [map zoomOnCurrentAnnotationsIncludingUserLocation:YES spanCorrection:0.2 animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
