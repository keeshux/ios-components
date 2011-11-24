/*
 * KSProgressDownloader.h
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
#import "ASIHTTPRequest.h"

@protocol KSProgressDownloaderDelegate;

@interface KSProgressDownloader : NSObject<ASIHTTPRequestDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) NSString *message; // must be a single line
@property (nonatomic, copy) NSString *cancelTitle;

@property (nonatomic, assign) id<KSProgressDownloaderDelegate> delegate;

+ (KSProgressDownloader *) instance;

- (void) downloadWithRequest:(ASIHTTPRequest *)aRequest;

@end

@protocol KSProgressDownloaderDelegate

- (void) downloader:(KSProgressDownloader *)downloader didDownloadURL:(NSURL *)url toFile:(NSString *)file;
- (void) downloader:(KSProgressDownloader *)downloader didFailToDownloadURL:(NSURL *)url errorCode:(int)errorCode;

@end
