//
//  VC_NSString_Digest.h
//  Components
//
//  Created by Davide De Rosa on 11/15/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSString_Digest : LegacyViewController

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UITextField *outputField;
@property (nonatomic, strong) UISegmentedControl *digestChoice;

- (void) updateDigest;

@end
