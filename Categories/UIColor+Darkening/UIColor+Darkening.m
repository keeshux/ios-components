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
