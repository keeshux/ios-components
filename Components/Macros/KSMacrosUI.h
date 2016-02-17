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

#ifndef KSMacrosUI_h
#define KSMacrosUI_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static inline CGFloat KSUIScreenWidth()
{
    return [[UIScreen mainScreen] bounds].size.width;
}

static inline CGFloat KSUIScreenHeight()
{
    return [[UIScreen mainScreen] bounds].size.height;
}

static inline CGFloat KSUIScreenMaxLength()
{
    return MAX(KSUIScreenWidth(), KSUIScreenHeight());
}

static inline CGFloat KSUIScreenMinLength()
{
    return MIN(KSUIScreenWidth(), KSUIScreenHeight());
}

static inline BOOL KSUIIsPhone()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

static inline BOOL KSUIIsPad()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

static inline BOOL KSUIIsRetina()
{
    return ([[UIScreen mainScreen] scale] > 1.9);
}

static inline BOOL KSUIIsPadRetina()
{
    return (KSUIIsPad() && KSUIIsRetina());
}

static inline BOOL KSUIIsPadNonRetina()
{
    return (KSUIIsPad() && !KSUIIsRetina());
}

static inline BOOL KSUIIsPhone5()
{
    return (KSUIIsPhone() && (KSUIScreenMaxLength() == 568.0));
}

static inline BOOL KSUIIsPhone6()
{
    return (KSUIIsPhone() && (KSUIScreenMaxLength() == 667.0));
}

static inline BOOL KSUIIsPhone6Plus()
{
    return (KSUIIsPhone() && (KSUIScreenMaxLength() == 736.0));
}

static inline BOOL KSUIIsPhone5OrLater()
{
    return (KSUIIsPhone() && (KSUIScreenMaxLength() >= 568.0));
}

static inline UIColor *KSUIColorFromRGBA(const NSUInteger r, const NSUInteger g, const NSUInteger b, const NSUInteger a)
{
    return [UIColor colorWithRed:(r / 255.0)
                           green:(g / 255.0)
                            blue:(b / 255.0)
                           alpha:(a / 255.0)];
}

static inline UIColor *KSUIColorFromRGB(const NSUInteger r, const NSUInteger g, const NSUInteger b)
{
    return KSUIColorFromRGBA(r, g, b, 255.0);
}

static inline UIColor *KSUIColorFromHex(const NSUInteger hex)
{
    const CGFloat r = ((hex >> 16) & 0xFF) / 255.0;
    const CGFloat g = ((hex >> 8) & 0xFF) / 255.0;
    const CGFloat b = (hex & 0xFF) / 255.0;
    
    return KSUIColorFromRGB(r, g, b);
}

#define KSUISF(format, ...)     [NSString stringWithFormat:format, __VA_ARGS__]

static inline NSString *KSUIString(NSString *key)
{
    return NSLocalizedString(key, nil);
}

static inline NSString *KSUITableString(NSString *table, NSString *key)
{
    return NSLocalizedStringFromTable(key, table, nil);
}

BOOL KSUIPhoneCanCall(void);

BOOL KSUIPhoneCall(NSString *phone);

#endif
