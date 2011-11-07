/*
 * KSProgressDownloader.m
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

#import "KSProgressDownloader.h"
#import "ASIDownloadCache.h"

@interface KSProgressDownloader ()

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSMutableDictionary *originalHeaders;
@property (nonatomic, retain) UIAlertView *progressAlert;

- (void) cleanUpRequest;

@end

//

@implementation KSProgressDownloader

@synthesize message;
//@synthesize cancelTitle;

@synthesize request;
@synthesize originalHeaders;
@synthesize progressAlert;

@synthesize delegate;

+ (KSProgressDownloader *) instance
{
    static KSProgressDownloader *instance = nil;
    if (!instance) {
        instance = [[KSProgressDownloader alloc] init];
    }
    return instance;
}

- (id) init
{
    if ((self = [super init])) {
        self.message = @"Downloading";
//        self.cancelTitle = @"Cancel";
    }
    return self;
}

- (void) dealloc
{
    self.message = nil;
//    self.cancelTitle = nil;

    request.downloadProgressDelegate = nil;
    request.delegate = nil;
    self.request = nil;
    self.originalHeaders = nil;
    self.progressAlert = nil;

    [super dealloc];
}

- (void) downloadWithRequest:(ASIHTTPRequest *)aRequest
{
    [request cancel];
    [self cleanUpRequest];

    // hide and release old alert
    [progressAlert dismissWithClickedButtonIndex:0 animated:NO];
    self.progressAlert = nil;

    // create new alert
    progressAlert = [[UIAlertView alloc] initWithTitle:nil
                                               message:message
                                              delegate:self
//                                     cancelButtonTitle:cancelTitle
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];

    // add progress to alert
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.frame = CGRectMake(30, 80, 225, 90);
    [progressAlert addSubview:progressView];
    [progressView release];

    // show alert
    [progressAlert show];

    // retain request
    self.request = aRequest;
    self.originalHeaders = aRequest.requestHeaders;

    // extend HTTP request
    request.downloadCache = [ASIDownloadCache sharedCache];
    request.delegate = self;
    request.downloadProgressDelegate = progressView;
    request.willRedirectSelector = @selector(downloadRedirected:toNewURL:);
    request.didFinishSelector = @selector(downloadDone:);
    request.didFailSelector = @selector(downloadWrong:);
    [request startAsynchronous];
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    [self cleanUpRequest];
}

#pragma mark - Custom delegate

- (void) downloadRedirected:(ASIHTTPRequest *)aRequest toNewURL:(NSURL *)newURL
{
    NSLog(@"%@ will redirect to %@", request.url, newURL);

    // restore original headers
    request.requestHeaders = originalHeaders;
    [request redirectToURL:newURL];
}

- (void) downloadDone:(ASIHTTPRequest *)aRequest
{
    const int statusCode = request.responseStatusCode;
    NSData *data = request.responseData;
    NSString *cachedFile = nil;

    if (data || [request didUseCachedResponse]) {
        cachedFile = [[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request];

        [delegate downloader:self didDownloadURL:request.url toFile:cachedFile];
    } else {
        [delegate downloader:self didFailToDownloadURL:request.url errorCode:statusCode];
    }

    [self cleanUpRequest];
    [progressAlert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void) downloadWrong:(ASIHTTPRequest *)aRequest
{
    [delegate downloader:self didFailToDownloadURL:request.url errorCode:request.responseStatusCode];

    [self cleanUpRequest];
    [progressAlert dismissWithClickedButtonIndex:0 animated:NO];
}

#pragma mark - Private methods

- (void) cleanUpRequest
{
    request.downloadProgressDelegate = nil;
    request.delegate = nil;
    self.request = nil;
}

@end
