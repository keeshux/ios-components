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

#import "UIAcceleration+DeviceAngle.h"

@implementation UIAcceleration (DeviceAngle)

static inline CGFloat normalize(const CGFloat value) {
    return MIN(MAX(value, -1.0), 1.0);
}

- (CGPoint)deviceAngle
{
    CGPoint angle;

//    NSLog(@"acceleration = {%f, %f, %f}", self.x, self.y, self.z);

    angle.x = -asin(normalize(self.x));
    angle.y = -asin(normalize(self.y));
    
    if (self.z > 0.0) {
        angle.x = M_PI - angle.x;
        angle.y = M_PI - angle.y;
    } else {
        if (angle.x < 0.0) {
            angle.x += 2 * M_PI;
        } else if (angle.x >= 2 * M_PI) {
            angle.x = 0.0;
        }
        if (angle.y < 0.0) {
            angle.y += 2 * M_PI;
        } else if (angle.y >= 2 * M_PI) {
            angle.y = 0.0;
        }
    }
    
    return angle;
}

@end
