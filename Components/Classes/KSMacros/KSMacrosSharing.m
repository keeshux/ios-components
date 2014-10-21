//
// Copyright (c) 2014, Davide De Rosa
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

#import <Social/Social.h>

#import "KSMacrosSharing.h"
#import "KSMacrosUI.h"

void KSSharingFacebookOpenPage(NSString *pageId, NSString *fallbackURL)
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:KSUISF(@"fb://profile/%@", pageId)];
    
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
    else {
        [app openURL:[NSURL URLWithString:fallbackURL]];
    }
}

static inline void KSSharingPostStatus(UIViewController *controller, NSString *serviceType, NSString *status, UIImage *image)
{
    SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composer setInitialText:status];
    if (image) {
        [composer addImage:image];
    }
    [controller presentViewController:composer animated:YES completion:NULL];
}

void KSSharingFacebookPostStatus(UIViewController *controller, NSString *status, UIImage *image)
{
    KSSharingPostStatus(controller, SLServiceTypeFacebook, status, image);
}

void KSSharingTwitterPostStatus(UIViewController *controller, NSString *status, UIImage *image)
{
    KSSharingPostStatus(controller, SLServiceTypeTwitter, status, image);
}
