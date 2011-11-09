/*
 * UIBarButtonItem+CustomImage.h
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

#import <Foundation/Foundation.h>

// NOTE: customView is an UIButton

@interface UIBarButtonItem (CustomImage)

+ (id) itemWithBackgroundImage:(UIImage *)image;
+ (id) itemWithBackgroundImage:(UIImage *)image target:(id)target action:(SEL)action;
- (void) setCustomButtonTitle:(NSString *)title forState:(UIControlState)state;
- (void) setCustomButtonTitleColor:(UIColor *)color forState:(UIControlState)state;

+ (id) itemWithImage:(UIImage *)image;
+ (id) itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

@end
