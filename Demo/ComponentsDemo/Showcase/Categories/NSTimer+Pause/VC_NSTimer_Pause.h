//
//  VC_NSTimer_Pause.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/18/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSTimer_Pause : UIViewController {
    NSUInteger seconds;
}

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) NSTimer *timer;

@end
