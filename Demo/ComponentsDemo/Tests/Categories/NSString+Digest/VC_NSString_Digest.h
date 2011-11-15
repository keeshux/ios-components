//
//  VC_NSString_Digest.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/15/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSString_Digest : UIViewController

@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UITextField *outputField;
@property (nonatomic, retain) UISegmentedControl *digestChoice;

- (void) updateDigest;

@end
