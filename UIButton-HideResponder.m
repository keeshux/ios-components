/*
 * UIButton-HideResponder.m
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

#import "UIButton-HideResponder.h"

@implementation UIButton (HideResponder)

+ (id) buttonWithResponderToHide:(UIResponder *)responder inView:(UIView *)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.hidden = YES;
    button.opaque = NO;
    button.frame = view.frame;
    [button addTarget:responder action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
