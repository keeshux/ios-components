//
// Copyright (c) 2011, Davide De Rosa
// All rights reserved.
//
// This code is distributed under the terms and conditions of the BSD license.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "MKMapView+Zoom.h"

@implementation MKMapView (Zoom)

- (void)zoomOnCurrentAnnotationsIncludingUserLocation:(BOOL)includeUserLocation animated:(BOOL)animated
{
    [self zoomOnCurrentAnnotationsIncludingUserLocation:includeUserLocation spanCorrection:0.1 animated:animated];
}

- (void)zoomOnCurrentAnnotationsIncludingUserLocation:(BOOL)includeUserLocation spanCorrection:(CGFloat)spanCorrection animated:(BOOL)animated
{
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithArray:self.annotations];

    // optionally exclude user location annotation
    if (!includeUserLocation) {
        [annotations removeObject:self.userLocation];
    }
    
    [self zoomOnAnnotations:annotations spanCorrection:spanCorrection animated:animated];
    [annotations release];
}

- (void)zoomOnAnnotations:(NSArray *)customAnnotations animated:(BOOL)animated
{
    [self zoomOnAnnotations:customAnnotations spanCorrection:0.1 animated:animated];
}

- (void)zoomOnAnnotations:(NSArray *)customAnnotations spanCorrection:(CGFloat)spanCorrection animated:(BOOL)animated
{
    const NSUInteger annotationsCount = [customAnnotations count];
    
    if (annotationsCount == 0) {
        return;
    } else if (annotationsCount == 1) {
        CLLocation *center = [customAnnotations objectAtIndex:0];
        
        // zoom the only coordinate with a radius
        if (CLLocationCoordinate2DIsValid(center.coordinate)) {
            [self setRegion:MKCoordinateRegionMake(center.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:animated];
        }
        
        return;
    }
    
    CLLocationCoordinate2D nw = CLLocationCoordinate2DMake(90, 180);
    CLLocationCoordinate2D se = CLLocationCoordinate2DMake(-90, -180);
    
    for (id<MKAnnotation> ann in customAnnotations) {
        if (ann.coordinate.latitude < nw.latitude) {
            nw.latitude = ann.coordinate.latitude;
        }
        if (ann.coordinate.latitude > se.latitude) {
            se.latitude = ann.coordinate.latitude;
        }
        if (ann.coordinate.longitude < nw.longitude) {
            nw.longitude = ann.coordinate.longitude;
        }
        if (ann.coordinate.longitude > se.longitude) {
            se.longitude = ann.coordinate.longitude;
        }
    }
    
    //    DDLog(@"north-west = {%f,%f}", nw.latitude, nw.longitude);
    //    DDLog(@"south-east = {%f,%f}", se.latitude, se.longitude);
    
    MKCoordinateRegion zoom;
    zoom.center.latitude = nw.latitude - (nw.latitude - se.latitude) / 2.0;
    zoom.center.longitude = nw.longitude + (se.longitude - nw.longitude) / 2.0;
    zoom.span.latitudeDelta = fabs(nw.latitude - se.latitude) * (1.0 + spanCorrection);
    zoom.span.longitudeDelta = fabs(se.longitude - nw.longitude) * (1.0 + spanCorrection);
    
    const MKCoordinateRegion fitZoom = [self regionThatFits:zoom];
    [self setRegion:fitZoom animated:animated];
}

@end
