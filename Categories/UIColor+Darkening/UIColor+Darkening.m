/*
 * UIColor+Darkening.m
 *
 * Copyright 2012 Davide De Rosa
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

#import "UIColor+Darkening.h"

@implementation UIColor (Darkening)

- (UIColor *)darkenedColorWithFactor:(CGFloat)factor
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat darkenedComponents[4];
    switch (CGColorGetNumberOfComponents(self.CGColor)) {
        case 2:
            darkenedComponents[0] = components[0] * factor;
            darkenedComponents[1] = components[0] * factor;
            darkenedComponents[2] = components[0] * factor;
            darkenedComponents[3] = components[1];
            break;
        case 4:
            darkenedComponents[0] = components[0] * factor;
            darkenedComponents[1] = components[1] * factor;
            darkenedComponents[2] = components[2] * factor;
            darkenedComponents[3] = components[3];
            break;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef darkenedCG = CGColorCreate(colorSpace, darkenedComponents);
	UIColor *darkened = [UIColor colorWithCGColor:darkenedCG];
	CGColorSpaceRelease(colorSpace);
	CGColorRelease(darkenedCG);
    return darkened;
}

@end
