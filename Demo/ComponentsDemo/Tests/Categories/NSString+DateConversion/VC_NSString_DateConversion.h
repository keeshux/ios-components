//
//  VC_NSString_DateConversion.h
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/6/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_NSString_DateConversion : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputDate;
@property (nonatomic, strong) UITextField *inputFormat;
@property (nonatomic, strong) UITextField *outputFormat;
@property (nonatomic, strong) UILabel *outputDate;
@property (nonatomic, strong) UIButton *convertButton;

- (void) convertDate:(id)sender;

@end
