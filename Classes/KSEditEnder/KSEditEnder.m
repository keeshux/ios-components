/*
 * KSEditEnder.m
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

#import "KSEditEnder.h"

@interface KSEditEnder ()

- (void) endEditingInSuperview;

@end

@implementation KSEditEnder

@synthesize force;

+ (id) enderWithView:(UIView *)view
{
    return [[[self alloc] initWithView:view] autorelease];
}

- (id) initWithView:(UIView *)view
{
    if ((self = [super initWithFrame:view.frame])) {

        // initially disabled
        self.userInteractionEnabled = NO;
        self.opaque = NO;

        // will end editing in future superview (the view parameter)
        [self addTarget:self action:@selector(endEditingInSuperview) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self];
    }
    return self;
}

- (void) endEditingInSuperview
{
    [self.superview endEditing:force];
}

@end
