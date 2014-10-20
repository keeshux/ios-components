//
//  VC_NSTimer_Pause.h
//  Components
//
//  Created by Davide De Rosa on 1/18/12.
//  Copyright (c) 2012 Davide De Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSTimer_Pause : LegacyViewController {
    NSUInteger seconds;
}

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) NSTimer *timer;

@end
