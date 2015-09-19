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

#import "MBProgressHUD.h"

#import "KSProgressDownloader.h"

@interface KSProgressDownloader () {
    NSInteger _contentLength;
    NSInteger _downloadedBytes;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableDictionary *originalHeaders;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) NSFileHandle *destination;

- (void)handleConnectionStatus:(int)statusCode error:(NSError *)error;
- (void)cleanUpRequest;

@end

@implementation KSProgressDownloader

+ (instancetype)downloaderWithWindow:(UIWindow *)window
{
    return [[[self alloc] initWithWindow:window] autorelease];
}

- (instancetype)initWithWindow:(UIWindow *)window
{
    if ((self = [super init])) {
        self.window = window;
        self.message = @"Downloading";
        self.cancelTitle = @"Cancel";
    }
    return self;
}

- (void)dealloc
{
    self.window = nil;
    self.message = nil;
    self.cancelTitle = nil;

    [self cleanUpRequest];
    self.destinationFile = nil;
    self.originalHeaders = nil;
    self.progressHUD = nil;

    [super ah_dealloc];
}

- (void)downloadWithRequest:(NSURLRequest *)request
{
    [self cleanUpRequest];

//    // hide and release old alert
//    [_progressAlert dismissWithClickedButtonIndex:0 animated:NO];
//    self.progressAlert = nil;
//    self.progressView = nil;
//
//    // create new alert
//    _progressAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                message:[NSString stringWithFormat:@"%@\n\n", _message]
//                                               delegate:self
//                                      cancelButtonTitle:_cancelTitle
//                                      otherButtonTitles:nil];
//
//    // add progress to alert
//    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    _progressView.frame = CGRectMake(30, 50, 225, 30);
//    [_progressAlert addSubview:_progressView];
//
//    // show alert
//    [_progressAlert show];
    
    [_progressHUD hide:NO];
    self.progressHUD = nil;
    
    _progressHUD = [[MBProgressHUD alloc] initWithWindow:_window];
    _progressHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _progressHUD.labelText = _message;
    [_window addSubview:_progressHUD];
    [_progressHUD show:YES];

    // TODO: caching

    // copy original request
    self.request = [[request copy] autorelease];
    self.connection = [NSURLConnection connectionWithRequest:_request delegate:self];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self cleanUpRequest];
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *) response;
    const NSInteger statusCode = urlResponse.statusCode;

    if (statusCode == 200) {
        _contentLength = [[[urlResponse allHeaderFields] objectForKey:@"Content-Length"] integerValue];
        _downloadedBytes = 0;

        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:_destinationFile error:nil];
        [fm createFileAtPath:_destinationFile contents:nil attributes:nil];
        self.destination = [NSFileHandle fileHandleForWritingAtPath:_destinationFile];

        NSLog(@"%@: Download is starting (%lu bytes), %@", [self class], (unsigned long)_contentLength, _destination);
    } else {

        // stop here, do NOT download
        [_connection cancel];
        
        if ((statusCode > 300) && (statusCode < 304)) {
            NSLog(@"%@: Redirected", [self class]);

            // TODO: handle redirection

        } else if (statusCode == 304) {
            NSLog(@"%@: File not modified", [self class]);

            // TODO: caching

        } else {
            [self handleConnectionStatus:(int)statusCode error:nil];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"%@: Received %lu bytes", [self class], (unsigned long)[data length]);

    [_destination seekToEndOfFile];
    [_destination writeData:data];

    // update progress
    _downloadedBytes += [data length];
    if (_contentLength > 0) {
        const float progress = (float)_downloadedBytes / _contentLength;
//        _progressView.progress = progress;
        _progressHUD.progress = progress;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@: Download finished", [self class]);

    NSURL *url = [_request.URL ah_retain];
    NSString *file = [_destinationFile ah_retain];
//    [_progressAlert dismissWithClickedButtonIndex:0 animated:YES];
    [_progressHUD hide:YES];

    [_delegate downloader:self didDownloadURL:url toFile:file];
    [url release];
    [file release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self handleConnectionStatus:-1 error:error];
}

#pragma mark Private methods

- (void)handleConnectionStatus:(int)statusCode error:(NSError *)error
{
    if (error) {
        NSLog(@"%@: Download failed (%d), reason: %@", [self class], statusCode, error);
    } else {
        NSLog(@"%@: Download failed (%d)", [self class], statusCode);
    }
    
    NSURL *url = [_request.URL ah_retain];
//    [_progressAlert dismissWithClickedButtonIndex:0 animated:YES];
    [_progressHUD hide:YES];
    
    [_delegate downloader:self didFailToDownloadURL:url errorCode:0];
    [url release];
}

- (void) cleanUpRequest
{
    [_destination closeFile];
    [_connection cancel];
    self.destination = nil;
    self.connection = nil;
    self.request = nil;
}

@end
