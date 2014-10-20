//
//  VC_NSString_DateConversion.h
//  Components
//
//  Created by Davide De Rosa on 11/6/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSString_DateConversion : LegacyViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputDate;
@property (nonatomic, strong) UITextField *inputFormat;
@property (nonatomic, strong) UITextField *outputFormat;
@property (nonatomic, strong) UILabel *outputDate;
@property (nonatomic, strong) UIButton *convertButton;

- (void) convertDate:(id)sender;

@end
