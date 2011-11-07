//
//  VC_KSProgressDownloader.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 10/23/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_KSProgressDownloader.h"

@implementation VC_KSProgressDownloader

@synthesize fileInfo;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"KSProgressDownloader";

    //

    self.fileInfo = [[UITextView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:fileInfo];
    [fileInfo release];

    KSProgressDownloader *downloader = [KSProgressDownloader instance];
    downloader.message = @"Downloading a PDF";
    downloader.delegate = self;

    NSURL *url = [NSURL URLWithString:@"http://algoritmico.com/files/crucio.pdf"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [downloader downloadWithRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.fileInfo = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - KSProgressDownloaderDelegate

- (void) downloader:(KSProgressDownloader *)downloader didDownloadURL:(NSURL *)url toFile:(NSString *)file
{
    NSLog(@"didDownloadURL:%@ toFile:%@", url, file);

    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&error];
    if (!error) {
        NSLog(@"file attributes = %@", attributes);
        fileInfo.text = [attributes description];
    }
}

- (void) downloader:(KSProgressDownloader *)downloader didFailToDownloadURL:(NSURL *)url errorCode:(int)errorCode
{
    NSLog(@"didFailToDownloadURL:%@ (code %d)", url, errorCode);
}

@end
