/*
 * KSBasicMapAnnotation.m
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

#import "KSBasicMapAnnotation.h"

@implementation KSBasicMapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

+ (id) annotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle
{
    return [[[self alloc] initWithCoordinate:aCoordinate title:aTitle subtitle:aSubtitle] autorelease];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle
{
    if ((self = [super init])) {
        self.coordinate = aCoordinate;
        self.title = aTitle;
        self.subtitle = aSubtitle;
    }
    return self;
}

- (void) dealloc
{
    self.title = nil;
    self.subtitle = nil;
    
    [super dealloc];
}

@end
