//
//  VC_KSProgressDownloader.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 10/23/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSProgressDownloader.h"

@interface VC_KSProgressDownloader : UIViewController <KSProgressDownloaderDelegate>

@property (nonatomic, retain) UITextView *fileInfo;

@end
