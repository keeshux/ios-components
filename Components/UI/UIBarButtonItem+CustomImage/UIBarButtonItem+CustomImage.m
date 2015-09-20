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

#import "UIBarButtonItem+CustomImage.h"

@implementation UIBarButtonItem (CustomImage)

+ (instancetype)itemWithBackgroundImage:(UIImage *)image
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    aButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];

    return [[UIBarButtonItem alloc] initWithCustomView:aButton];
}

+ (instancetype)itemWithBackgroundImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [UIBarButtonItem itemWithBackgroundImage:image];
    UIButton *aButton = (UIButton *) item.customView;
    [aButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return item;
}

- (void)setCustomButtonTitle:(NSString *)title forState:(UIControlState)state
{
    [(UIButton *)self.customView setTitle:title forState:state];
}

- (void)setCustomButtonTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [(UIButton *)self.customView setTitleColor:color forState:state];
}

+ (instancetype)itemWithImage:(UIImage *)image
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    return [[UIBarButtonItem alloc] initWithCustomView:aButton];
}

+ (instancetype)itemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:image];
    UIButton *aButton = (UIButton *)item.customView;
    [aButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return item;
}

@end
