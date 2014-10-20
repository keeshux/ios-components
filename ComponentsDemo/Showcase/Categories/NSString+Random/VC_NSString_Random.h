//
//  VC_NSString_Random.h
//  Components
//
//  Created by Davide De Rosa on 11/15/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSString_Random : LegacyViewController

@property (nonatomic, strong) UITextField *outputField;

- (void) generateString;

@end
