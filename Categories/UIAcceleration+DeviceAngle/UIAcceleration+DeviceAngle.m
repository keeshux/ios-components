/*
 * UIAcceleration+DeviceAngle.m
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
