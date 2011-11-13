/*
 * MKMapView+Zoom.h
 *
 * Copyright 2011 Davide De Rosa
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "MKMapView+Zoom.h"

@implementation MKMapView (Zoom)

- (void) zoomOnCurrentAnnotazionsIncludingUserLocation:(BOOL)includeUserLocation animated:(BOOL)animated
{
    [self zoomOnCurrentAnnotazionsIncludingUserLocation:includeUserLocation spanCorrection:0.1 animated:animated];
}

- (void) zoomOnCurrentAnnotazionsIncludingUserLocation:(BOOL)includeUserLocation spanCorrection:(CGFloat)spanCorrection animated:(BOOL)animated
{
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithArray:self.annotations];

    // optionally exclude user location annotation
    if (!includeUserLocation) {
        [annotations removeObject:self.userLocation];
    }
    
    [self zoomOnAnnotations:annotations spanCorrection:spanCorrection animated:animated];
    [annotations release];
}

- (void) zoomOnAnnotations:(NSArray *)customAnnotations animated:(BOOL)animated
{
    [self zoomOnAnnotations:customAnnotations spanCorrection:0.1 animated:animated];
}

- (void) zoomOnAnnotations:(NSArray *)customAnnotations spanCorrection:(CGFloat)spanCorrection animated:(BOOL)animated
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
    zoom.span.latitudeDelta = (nw.latitude - se.latitude) * (1.0 + spanCorrection);
    zoom.span.longitudeDelta = (se.longitude - nw.longitude) * (1.0 + spanCorrection);
    
    const MKCoordinateRegion fitZoom = [self regionThatFits:zoom];
    [self setRegion:fitZoom animated:animated];
}

@end
