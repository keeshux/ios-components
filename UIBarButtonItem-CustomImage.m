/*
 * UIBarButtonItem-CustomImage.m
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

#import "UIBarButtonItem-CustomImage.m"

@implementation UIBarButtonItem (CustomImage)

+ (id) itemWithBackgroundImage:(UIImage *)image
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    aButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];

    return [[[UIBarButtonItem alloc] initWithCustomView:aButton] autorelease];    
}

+ (id) itemWithBackgroundImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [aButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    aButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];

    return [[[UIBarButtonItem alloc] initWithCustomView:aButton] autorelease];    
}

+ (id) itemWithImage:(UIImage *)image
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    return [[[UIBarButtonItem alloc] initWithCustomView:aButton] autorelease];    
}

+ (id) itemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [aButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:aButton] autorelease];    
}

@end
