//
//  VC_NSString_DateConversion.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/6/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSString_DateConversion : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) UITextField *inputDate;
@property (nonatomic, retain) UITextField *inputFormat;
@property (nonatomic, retain) UITextField *outputFormat;
@property (nonatomic, retain) UILabel *outputDate;
@property (nonatomic, retain) UIButton *convertButton;

- (void) convertDate:(id)sender;

@end
